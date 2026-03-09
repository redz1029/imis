using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditPlanProcessModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditPlanProcessModule
{
    public class AuditPlanProcessEndpoint : CarterModule
    {
        private const string _AuditPlanProcess = "AuditPlanProcess";

        public AuditPlanProcessEndpoint() : base("/AuditPlanProcess")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // =========================
            // CREATE
            // =========================
            app.MapPost("/", async ([FromBody] AuditPlanProcessDto dto, IAuditPlanProcessService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (dto == null) return Results.BadRequest("Request body is required.");

                try
                {
                    var created = await service.CreateAsync(dto, cancellationToken).ConfigureAwait(false);
                    await cache.EvictByTagAsync(_AuditPlanProcess, cancellationToken);
                    return Results.Created($"/AuditPlanProcess/{created.Id}", created);
                }
                catch (InvalidOperationException ex)
                {
                    return Results.BadRequest(ex.Message);
                }
            })
            .WithTags(_AuditPlanProcess);

            // =========================
            // GET ALL
            // =========================
            app.MapGet("/", async (IAuditPlanProcessService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return result != null && result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_AuditPlanProcess)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlanProcess), true);

            // =========================
            // GET PAGINATED
            // =========================
            app.MapGet("/paginated", async ([FromQuery] int page, [FromQuery] int pageSize, IAuditPlanProcessService service, CancellationToken cancellationToken) =>
            {
                if (page <= 0 || pageSize <= 0)
                    return Results.BadRequest("Page and PageSize must be greater than zero.");

                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_AuditPlanProcess)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlanProcess), true);

            // =========================
            // GET BY ID
            // =========================
            app.MapGet("/{id:int}", async (int id, IAuditPlanProcessService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_AuditPlanProcess)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlanProcess), true);

            // =========================
            // ACTIVATE
            // =========================
            app.MapPut("/{id:int}/activate", async (int id, IAuditPlanProcessService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.ActivateAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_AuditPlanProcess, cancellationToken);
                return Results.Ok(new { message = "Process activated successfully." });
            })
            .WithTags(_AuditPlanProcess);

            // =========================
            // DEACTIVATE
            // =========================
            app.MapPut("/{id:int}/deactivate", async (int id, IAuditPlanProcessService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.DeactivateAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_AuditPlanProcess, cancellationToken);
                return Results.Ok(new { message = "Process deactivated successfully." });
            })
            .WithTags(_AuditPlanProcess);

            // =========================
            // SOFT DELETE
            // =========================
            app.MapDelete("/{id:int}", async (int id, IAuditPlanProcessService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound(new { message = "Process not found." });

                await cache.EvictByTagAsync(_AuditPlanProcess, cancellationToken);
                return Results.Ok(new { message = "Process deleted successfully." });
            })
            .WithTags(_AuditPlanProcess);
        }
    }
}