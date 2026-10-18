using Base.Auths.Permissions;
using Carter;
using IMIS.Application.IsoAuditProcessModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.IsoAuditProcessModule
{
    public class IsoAuditProcessEndpoint : CarterModule
    {
        private const string _isoAuditProcessTag = "IsoAuditProcesses";

        public IsoAuditProcessEndpoint() : base("/isoAuditProcesses")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // --- CREATE / UPDATE ---
            app.MapPost("/", async ([FromBody] IsoAuditProcessDto dto, IIsoAuditProcessService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_isoAuditProcessTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_isoAuditProcessTag);

            // --- GET ALL ---
            app.MapGet("/", async (IIsoAuditProcessService service, CancellationToken cancellationToken) =>
            {
                var processes = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(processes);
            })
            .WithTags(_isoAuditProcessTag);

            // --- GET PAGINATED ---
            app.MapGet("/page", async (int page, int pageSize, IIsoAuditProcessService service, CancellationToken cancellationToken) =>
            {
                var paginated = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginated);
            })
            .WithTags(_isoAuditProcessTag);

            // --- UPDATE BY ID ---
            app.MapPut("/{id:int}", async (int id, [FromBody] IsoAuditProcessDto dto, IIsoAuditProcessService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existing = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existing == null)
                {
                    return Results.NotFound($"IsoAuditProcess with ID {id} not found.");
                }

                dto.Id = id; // Maintain integrity
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_isoAuditProcessTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_isoAuditProcessTag);

            // --- DELETE ---
            app.MapDelete("/{id:int}", async (int id, IIsoAuditProcessService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);
                await cache.EvictByTagAsync(_isoAuditProcessTag, cancellationToken);

                return result ? Results.Ok(new { message = "IsoAuditProcess deleted successfully." })
                              : Results.NotFound(new { message = "IsoAuditProcess not found." });
            })
            .WithTags(_isoAuditProcessTag);
        }
    }
}