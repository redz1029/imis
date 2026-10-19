using Base.Auths.Permissions;
using Carter;
using IMIS.Application.IsoAuditorModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.IsoAuditorModule
{
    public class IsoAuditorEndpoint : CarterModule
    {
        private const string _isoAuditorTag = "IsoAuditors";
        // Uncomment and update if you have the permission class ready
        // public readonly IsoAuditorPermission _permission = new();

        public IsoAuditorEndpoint() : base("/isoAuditors")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // --- CREATE / UPDATE ---
            app.MapPost("/", async (
                [FromBody] IsoAuditorDto dto,
                [FromServices] IIsoAuditorService service,
                [FromServices] IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_isoAuditorTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_isoAuditorTag);

            // --- GET ALL ---
            app.MapGet("/", async (
                [FromServices] IIsoAuditorService service,
                CancellationToken cancellationToken) =>
            {
                var auditors = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(auditors);
            })
            .WithTags(_isoAuditorTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_isoAuditorTag), true);

            // --- GET PAGINATED ---
            app.MapGet("/page", async (
                [FromQuery] int page,
                [FromQuery] int pageSize,
                [FromServices] IIsoAuditorService service,
                CancellationToken cancellationToken) =>
            {
                var paginated = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginated);
            })
            .WithTags(_isoAuditorTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_isoAuditorTag), true);

            // --- UPDATE BY ID ---
            app.MapPut("/{id:int}", async (
                int id,
                [FromBody] IsoAuditorDto dto,
                [FromServices] IIsoAuditorService service,
                [FromServices] IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var existing = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existing == null)
                {
                    return Results.NotFound($"IsoAuditor with ID {id} not found.");
                }

                dto.Id = id;
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_isoAuditorTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_isoAuditorTag);

            // --- DELETE ---
            app.MapDelete("/{id:int}", async (
                int id,
                [FromServices] IIsoAuditorService service,
                [FromServices] IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);
                await cache.EvictByTagAsync(_isoAuditorTag, cancellationToken);

                return result ? Results.Ok(new { message = "IsoAuditor deleted successfully." })
                              : Results.NotFound(new { message = "IsoAuditor not found." });
            })
            .WithTags(_isoAuditorTag);
        }
    }
}