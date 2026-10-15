using Base.Auths.Permissions;
using Carter;
using IMIS.Application.StandardVersionModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.StandardVersionModule
{
    public class StandardVersionEndpoint : CarterModule
    {
        private const string _tag = "StandardVersions";
        // Assuming a matching permission configuration structure exists
        // public readonly StandardVersionPermission _permission = new();

        public StandardVersionEndpoint() : base("/standardVersions")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // --- CREATE / UPDATE ---
            app.MapPost("/", async ([FromBody] StandardVersionDto dto, IStandardVersionService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // --- READ ALL ---
            app.MapGet("/", async (IStandardVersionService service, CancellationToken cancellationToken) =>
            {
                var list = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(list);
            })
            .WithTags(_tag)
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_tag), true);

            // --- UPDATE BY ID ---
            app.MapPut("/{id:int}", async (int id, [FromBody] StandardVersionDto dto, IStandardVersionService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existing = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existing == null)
                {
                    return Results.NotFound($"Standard Version with ID {id} not found.");
                }

                dto.Id = id; // Ensure ID consistency
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // --- READ PAGINATED ---
            app.MapGet("/page", async (int page, int pageSize, IStandardVersionService service, CancellationToken cancellationToken) =>
            {
                var paginated = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginated);
            })
            .WithTags(_tag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_tag), true);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // --- DELETE ---
            app.MapDelete("/{id:int}", async (int id, IStandardVersionService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);
                await cache.EvictByTagAsync(_tag, cancellationToken);

                return result ? Results.Ok(new { message = "Standard version deleted successfully." })
                              : Results.NotFound(new { message = "Standard version not found." });
            })
            .WithTags(_tag);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
        }
    }
}