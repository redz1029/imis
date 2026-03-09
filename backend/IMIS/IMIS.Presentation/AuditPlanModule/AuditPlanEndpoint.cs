using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditPlanModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditPlanModule
{
    public class AuditPlanEndpoint : CarterModule
    {
        private const string _auditPlanTag = "AuditPlan";

        public AuditPlanEndpoint() : base("/audit-plans")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/").WithTags(_auditPlanTag);

            #region GET ROUTES

            group.MapGet("/", async (IAuditPlanService service, CancellationToken ct) =>
            {
                var result = await service.GetAllAsync(ct);
                return result != null ? Results.Ok(result) : Results.NoContent();
            });

            group.MapGet("/{id:int}", async (int id, IAuditPlanService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdAsync(id, ct);
                return result != null ? Results.Ok(result) : Results.NotFound("Audit Plan not found.");
            });

            group.MapGet("/{id:int}/details", async (int id, IAuditPlanService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdWithDetailsAsync(id, ct);
                return result != null ? Results.Ok(result) : Results.NotFound("Audit Plan details not found.");
            });

            group.MapGet("/page", async ([FromQuery] int page, [FromQuery] int pageSize, IAuditPlanService service, CancellationToken ct) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, ct);
                return result != null && result.Items.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(p => p.Expire(TimeSpan.FromMinutes(2)).Tag(_auditPlanTag));

            #endregion

            #region FILTER ROUTES

            group.MapGet("/preparer/{preparerId}", async (string preparerId, IAuditPlanService service, CancellationToken ct) =>
            {
                var result = await service.GetByPreparerIdAsync(preparerId, ct);
                return result != null ? Results.Ok(result) : Results.NoContent();
            });

            group.MapGet("/approver/{approverId}", async (string approverId, IAuditPlanService service, CancellationToken ct) =>
            {
                var result = await service.GetByApproverIdAsync(approverId, ct);
                return result != null ? Results.Ok(result) : Results.NoContent();
            });

            group.MapGet("/status/{status}", async (string status, IAuditPlanService service, CancellationToken ct) =>
            {
                var result = await service.GetByStatusAsync(status, ct);
                return result != null ? Results.Ok(result) : Results.NoContent();
            });

            group.MapGet("/date-range", async ([FromQuery] DateTime start, [FromQuery] DateTime end, IAuditPlanService service, CancellationToken ct) =>
            {
                var result = await service.GetByDateRangeAsync(start, end, ct);
                return result != null ? Results.Ok(result) : Results.NoContent();
            });

            #endregion

            #region COMMAND ROUTES

            group.MapPost("/", async ([FromBody] AuditPlanDto dto, IAuditPlanService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var result = await service.CreateAsync(dto, ct);
                await cache.EvictByTagAsync(_auditPlanTag, ct);
                return Results.Created($"/audit-plans/{result.Id}", result);
            });

            group.MapPut("/{id:int}", async (int id, [FromBody] AuditPlanDto dto, IAuditPlanService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                dto.Id = id;
                var result = await service.UpdateAsync(dto, ct);
                await cache.EvictByTagAsync(_auditPlanTag, ct);
                return Results.Ok(result);
            });

            group.MapDelete("/{id:int}", async (int id, IAuditPlanService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var success = await service.SoftDeleteAsync(id, ct);
                if (!success) return Results.NotFound("Audit Plan not found.");

                await cache.EvictByTagAsync(_auditPlanTag, ct);
                return Results.Ok(new { message = "Audit Plan soft deleted successfully." });
            });

            #endregion

            #region WORKFLOW ROUTES

            group.MapPost("/{id:int}/submit", async (int id, IAuditPlanService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var result = await service.SubmitForApprovalAsync(id, ct);
                if (result == null) return Results.NotFound();

                await cache.EvictByTagAsync(_auditPlanTag, ct);
                return Results.Ok(result);
            });

            group.MapPost("/{id:int}/approve", async (int id, [FromQuery] string approverId, IAuditPlanService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var result = await service.ApproveAsync(id, approverId, ct);
                if (result == null) return Results.NotFound();

                await cache.EvictByTagAsync(_auditPlanTag, ct);
                return Results.Ok(result);
            });

            group.MapPost("/{id:int}/reject", async (int id, [FromQuery] string approverId, [FromBody] string comments, IAuditPlanService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var result = await service.RejectAsync(id, approverId, comments, ct);
                if (result == null) return Results.NotFound();

                await cache.EvictByTagAsync(_auditPlanTag, ct);
                return Results.Ok(result);
            });

            #endregion
        }
    }
}