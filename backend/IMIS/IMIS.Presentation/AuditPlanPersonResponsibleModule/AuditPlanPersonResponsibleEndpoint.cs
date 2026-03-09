using Carter;
using IMIS.Application.AuditPlanPersonResponsibleModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditPlanPersonResponsibleModule
{
    public class AuditPlanPersonResponsibleEndpoint : CarterModule
    {
        private const string _tag = "AuditPlanPersonResponsible";

        public AuditPlanPersonResponsibleEndpoint() : base("/audit-plan-responsible-persons")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // =========================
            // GET ALL
            // =========================
            app.MapGet("/", async (IAuditPlanPersonResponsibleService service, CancellationToken ct) =>
            {
                var result = await service.GetAllAsync(ct).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_tag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_tag), true);

            // =========================
            // GET BY ID
            // =========================
            app.MapGet("/{id:int}", async (int id, IAuditPlanPersonResponsibleService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdAsync(id, ct).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.NotFound(new { message = "Responsible person not found." });
            })
            .WithTags(_tag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_tag), true);

            // =========================
            // GET PAGINATED
            // =========================
            app.MapGet("/page", async ([FromQuery] int page, [FromQuery] int pageSize, IAuditPlanPersonResponsibleService service, CancellationToken ct) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, ct).ConfigureAwait(false);
                return result != null && result.Items.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_tag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_tag), true);

            // =========================
            // CREATE
            // =========================
            app.MapPost("/", async ([FromBody] AuditPlanPersonResponsibleDto dto, IAuditPlanPersonResponsibleService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var result = await service.CreateAsync(dto, ct).ConfigureAwait(false);
                await cache.EvictByTagAsync(_tag, ct);
                return Results.Created($"/audit-plan-responsible-persons/{result.Id}", result);
            })
            .WithTags(_tag);

            // =========================
            // UPDATE
            // =========================
            app.MapPut("/{id:int}", async (int id, [FromBody] AuditPlanPersonResponsibleDto dto, IAuditPlanPersonResponsibleService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var existing = await service.GetByIdAsync(id, ct).ConfigureAwait(false);
                if (existing == null) return Results.NotFound(new { message = $"Person with ID {id} not found." });

                dto.Id = id;
                var result = await service.UpdateAsync(dto, ct).ConfigureAwait(false);
                await cache.EvictByTagAsync(_tag, ct);
                return Results.Ok(result);
            })
            .WithTags(_tag);

            // =========================
            // DELETE (SOFT)
            // =========================
            app.MapDelete("/{id:int}", async (int id, IAuditPlanPersonResponsibleService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var success = await service.SoftDeleteAsync(id, ct).ConfigureAwait(false);
                if (!success) return Results.NotFound(new { message = "Person not found." });

                await cache.EvictByTagAsync(_tag, ct);
                return Results.Ok(new { message = "Responsible person soft deleted successfully." });
            })
            .WithTags(_tag);

            // =========================
            // PATCH STATUS
            // =========================
            app.MapPatch("/{id:int}/activate", async (int id, IAuditPlanPersonResponsibleService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var success = await service.ActivateAsync(id, ct).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_tag, ct);
                return Results.Ok(new { message = "Person activated successfully." });
            })
            .WithTags(_tag);

            app.MapPatch("/{id:int}/deactivate", async (int id, IAuditPlanPersonResponsibleService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var success = await service.DeactivateAsync(id, ct).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_tag, ct);
                return Results.Ok(new { message = "Person deactivated successfully." });
            })
            .WithTags(_tag);
        }
    }
}