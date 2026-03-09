using Carter;
using IMIS.Application.AuditPlanApprovalModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditPlanApprovalModule
{
    public class AuditPlanApprovalEndpoint : CarterModule
    {
        private const string _approvalTag = "AuditPlanApproval";
        public readonly AuditPlanApprovalPermission _AuditPlanApprovalPermission = new();

        public AuditPlanApprovalEndpoint() : base("/audit-plan-approvals")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            #region GET ROUTES

            app.MapGet("/", async (IAuditPlanApprovalService service, CancellationToken ct) =>
            {
                var result = await service.GetAllAsync(ct).ConfigureAwait(false);
                return result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_approvalTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_approvalTag), true);

            app.MapGet("/{id:int}", async (int id, IAuditPlanApprovalService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdAsync(id, ct).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.NotFound(new { message = "Approval record not found." });
            })
            .WithTags(_approvalTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_approvalTag), true);

            app.MapGet("/page", async ([FromQuery] int page, [FromQuery] int pageSize, IAuditPlanApprovalService service, CancellationToken ct) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, ct).ConfigureAwait(false);
                return result != null && result.Items.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_approvalTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_approvalTag), true);

            #endregion

            #region FILTER ROUTES

            app.MapGet("/plan/{auditPlanId:int}", async (int auditPlanId, IAuditPlanApprovalService service, CancellationToken ct) =>
            {
                var result = await service.GetByAuditPlanIdAsync(auditPlanId, ct).ConfigureAwait(false);
                return result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_approvalTag);

            app.MapGet("/approver/{approverId:int}", async (int approverId, IAuditPlanApprovalService service, CancellationToken ct) =>
            {
                var result = await service.GetByApproverIdAsync(approverId, ct).ConfigureAwait(false);
                return result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_approvalTag);

            app.MapGet("/date-range", async ([FromQuery] DateTime start, [FromQuery] DateTime end, IAuditPlanApprovalService service, CancellationToken ct) =>
            {
                var result = await service.GetByDateRangeAsync(start, end, ct).ConfigureAwait(false);
                return result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_approvalTag);

            #endregion

            #region WORKFLOW / COMMAND ROUTES

            app.MapPost("/", async ([FromBody] AuditPlanApprovalDto dto, IAuditPlanApprovalService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                await service.SaveOrUpdateAsync(dto, ct).ConfigureAwait(false);
                await cache.EvictByTagAsync(_approvalTag, ct).ConfigureAwait(false);
                return Results.Ok(dto);
            })
            .WithTags(_approvalTag);

            app.MapPost("/approve", async ([FromQuery] int auditPlanId, [FromQuery] int approverId, [FromBody] string? comments, IAuditPlanApprovalService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var result = await service.ApproveAuditPlanAsync(auditPlanId, approverId, comments, ct).ConfigureAwait(false);
                await cache.EvictByTagAsync(_approvalTag, ct).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_approvalTag);

            app.MapPost("/reject", async ([FromQuery] int auditPlanId, [FromQuery] int approverId, [FromBody] string comments, IAuditPlanApprovalService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var result = await service.RejectAuditPlanAsync(auditPlanId, approverId, comments, ct).ConfigureAwait(false);
                await cache.EvictByTagAsync(_approvalTag, ct).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_approvalTag);

            app.MapDelete("/{id:int}", async (int id, IAuditPlanApprovalService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var success = await service.SoftDeleteAsync(id, ct).ConfigureAwait(false);
                if (!success) return Results.NotFound(new { message = "Approval record not found." });

                await cache.EvictByTagAsync(_approvalTag, ct).ConfigureAwait(false);
                return Results.Ok(new { message = "Approval record soft deleted." });
            })
            .WithTags(_approvalTag);

            #endregion
        }
    }
}