using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditPlanApprovalModule;
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
        private const string _auditApprovalTag = "AuditPlanApprovals";

        public AuditPlanApprovalEndpoint() : base("/auditPlanApprovals")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // --- CREATE / UPDATE ---
            app.MapPost("/", async (
                [FromBody] AuditPlanApprovalDto dto,
                [FromServices] IAuditPlanApprovalService service,
                [FromServices] IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditApprovalTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditApprovalTag);

            // --- GET ALL ---
            app.MapGet("/", async (
                [FromServices] IAuditPlanApprovalService service,
                CancellationToken cancellationToken) =>
            {
                var approvals = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(approvals);
            })
            .WithTags(_auditApprovalTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditApprovalTag), true);

            // --- GET PAGINATED ---
            app.MapGet("/page", async (
                [FromQuery] int page,
                [FromQuery] int pageSize,
                [FromServices] IAuditPlanApprovalService service,
                CancellationToken cancellationToken) =>
            {
                var paginated = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginated is not null
                    ? Results.Ok(paginated)
                    : Results.NoContent();
            })
            .WithTags(_auditApprovalTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditApprovalTag), true);

            // --- UPDATE BY ID ---
            app.MapPut("/{id:int}", async (
                int id,
                [FromBody] AuditPlanApprovalDto dto,
                [FromServices] IAuditPlanApprovalService service,
                [FromServices] IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var existing = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existing == null)
                {
                    return Results.NotFound(new { message = $"Approval with ID {id} not found." });
                }

                dto.Id = id;
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditApprovalTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditApprovalTag);

            // --- DELETE (SOFT DELETE) ---
            app.MapDelete("/{id:int}", async (
                int id,
                [FromServices] IAuditPlanApprovalService service,
                [FromServices] IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);
                if (result)
                {
                    await cache.EvictByTagAsync(_auditApprovalTag, cancellationToken);
                    return Results.Ok(new { message = "Audit Plan Approval deleted successfully." });
                }

                return Results.NotFound(new { message = "Audit Plan Approval not found." });
            })
            .WithTags(_auditApprovalTag);
        }
    }
}