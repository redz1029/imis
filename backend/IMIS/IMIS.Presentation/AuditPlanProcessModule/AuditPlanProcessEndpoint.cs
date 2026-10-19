using Carter;
using IMIS.Application.AuditPlanProcessModule;
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

        public AuditPlanProcessEndpoint() : base("/api/AuditPlanProcess")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/api/AuditPlanProcess")
                           .WithTags(_AuditPlanProcess);

            // CREATE / UPDATE
            group.MapPost("/", async ([FromBody] AuditPlanProcessDto dto, IAuditPlanProcessService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                if (dto == null) return Results.BadRequest("Request body is required.");

                // Matching the Service's generic SaveOrUpdateAsync
                await service.SaveOrUpdateAsync(dto, ct).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditPlanProcess, ct).ConfigureAwait(false);

                return Results.Ok(new { message = "Process saved successfully." });
            });

            // GET ALL (Aligned with service.GetAll)
            group.MapGet("/", async (IAuditPlanProcessService service, CancellationToken ct) =>
            {
                var result = await service.GetAll(ct).ConfigureAwait(false);
                return result is not null && result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlanProcess));

            // GET PAGINATED
            group.MapGet("/paginated", async ([FromQuery] int page, [FromQuery] int pageSize, IAuditPlanProcessService service, CancellationToken ct) =>
            {
                if (page <= 0 || pageSize <= 0)
                    return Results.BadRequest("Page parameters must be positive.");

                var result = await service.GetPaginatedAsync(page, pageSize, ct).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlanProcess));

            // GET BY ID (Aligned with service.GetByIdAsync)
            group.MapGet("/{id:int}", async (int id, IAuditPlanProcessService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdAsync(id, ct).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlanProcess));

            // SOFT DELETE
            group.MapDelete("/{id:int}", async (int id, IAuditPlanProcessService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var success = await service.SoftDeleteAsync(id, ct).ConfigureAwait(false);
                if (!success) return Results.NotFound(new { message = "Process not found." });

                await cache.EvictByTagAsync(_AuditPlanProcess, ct).ConfigureAwait(false);
                return Results.Ok(new { message = "Process deleted successfully." });
            });
        }
    }
}