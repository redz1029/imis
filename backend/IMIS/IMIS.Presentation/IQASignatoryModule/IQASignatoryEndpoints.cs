using Carter;
using IMIS.Application.IQASignatoryModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.IQASignatoryModule
{
    // Request shapes for the mutation endpoints that take several plain
    // values rather than a full DTO — kept local to this file since they
    // are wire contracts only, not domain or application types.
    public record SubmitForApprovalRequest(string AuditEntityType, int AuditEntityId, string UserId);

    public record ApproveOrDisapproveRequest(
        string AuditEntityType,
        int AuditEntityId,
        string SignatoryId,
        bool Approve,
        string? Remarks);

    public record ResetOnDisapprovalRequest(string AuditEntityType, int AuditEntityId);

    public class IQASignatoryEndpoints : CarterModule
    {
        private const string _iqaSignatory = "IQASignatory";

        public IQASignatoryEndpoints() : base("/api/IQASignatory")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/api/IQASignatory")
                           .WithTags(_iqaSignatory);

            // ================================================================
            // GET METHODS
            // ================================================================

            // GET ALL BY AUDIT ENTITY TYPE
            group.MapGet("/type/{auditEntityType}", async (
                string auditEntityType,
                IIQAAuditSignatoryService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllByAuditEntityTypeAsync(auditEntityType, cancellationToken)
                    .ConfigureAwait(false);
                return result is not null && result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_iqaSignatory));

            // GET BY AUDIT ENTITY ID (e.g. all signatories for one AuditPlan)
            group.MapGet("/entity/{auditEntityType}/{auditEntityId:int}", async (
                string auditEntityType,
                int auditEntityId,
                IIQAAuditSignatoryService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByAuditEntityIdAsync(auditEntityType, auditEntityId, cancellationToken)
                    .ConfigureAwait(false);
                return result is not null && result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_iqaSignatory));

            // GET PAGINATED
            group.MapGet("/paginated", async (
                [FromQuery] string auditEntityType,
                [FromQuery] int page,
                [FromQuery] int pageSize,
                IIQAAuditSignatoryService service,
                CancellationToken cancellationToken) =>
            {
                if (string.IsNullOrWhiteSpace(auditEntityType) || page <= 0 || pageSize <= 0)
                    return Results.BadRequest("auditEntityType is required and page/pageSize must be positive.");

                var result = await service.GetPaginatedAsync(auditEntityType, page, pageSize, cancellationToken)
                    .ConfigureAwait(false);
                return Results.Ok(result);
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_iqaSignatory));

            // GET INHERITED TEMPLATES (walks up the office hierarchy)
            group.MapGet("/templates/inherited", async (
                [FromQuery] int officeId,
                [FromQuery] string auditEntityType,
                IIQAAuditSignatoryService service,
                CancellationToken cancellationToken) =>
            {
                if (officeId <= 0 || string.IsNullOrWhiteSpace(auditEntityType))
                    return Results.BadRequest("officeId and auditEntityType are required.");

                var result = await service.GetInheritedTemplatesAsync(officeId, auditEntityType, cancellationToken)
                    .ConfigureAwait(false);
                return result is not null && result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_iqaSignatory));

            // PROCESS SIGNATORIES (read-only computation — does not persist)
            group.MapGet("/process", async (
                [FromQuery] string auditEntityType,
                [FromQuery] int auditEntityId,
                [FromQuery] string userId,
                IIQAAuditSignatoryService service,
                CancellationToken cancellationToken) =>
            {
                if (string.IsNullOrWhiteSpace(auditEntityType) || auditEntityId <= 0 || string.IsNullOrWhiteSpace(userId))
                    return Results.BadRequest("auditEntityType, auditEntityId, and userId are required.");

                var result = await service.ProcessSignatoriesAsync(auditEntityType, auditEntityId, userId, cancellationToken)
                    .ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            });

            // GET NEXT PENDING SIGNATORY
            group.MapGet("/next", async (
                [FromQuery] string auditEntityType,
                [FromQuery] int auditEntityId,
                IIQAAuditSignatoryService service,
                CancellationToken cancellationToken) =>
            {
                if (string.IsNullOrWhiteSpace(auditEntityType) || auditEntityId <= 0)
                    return Results.BadRequest("auditEntityType and auditEntityId are required.");

                var result = await service.GetNextSignatoryAsync(auditEntityType, auditEntityId, cancellationToken)
                    .ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(1)).Tag(_iqaSignatory));

            // GET PENDING FOR CURRENT USER'S ROLE
            group.MapGet("/pending", async (
                [FromQuery] string roleId,
                [FromQuery] int page,
                [FromQuery] int pageSize,
                IIQAAuditSignatoryService service,
                CancellationToken cancellationToken) =>
            {
                if (string.IsNullOrWhiteSpace(roleId) || page <= 0 || pageSize <= 0)
                    return Results.BadRequest("roleId is required and page/pageSize must be positive.");

                var result = await service.GetPendingForCurrentUserAsync(roleId, page, pageSize, cancellationToken)
                    .ConfigureAwait(false);
                return result is not null && result.Any() ? Results.Ok(result) : Results.NoContent();
            });

            // IS DRAFT (no signatory rows persisted yet for this entity)
            group.MapGet("/isdraft", async (
                [FromQuery] string auditEntityType,
                [FromQuery] int auditEntityId,
                IIQAAuditSignatoryService service,
                CancellationToken cancellationToken) =>
            {
                if (string.IsNullOrWhiteSpace(auditEntityType) || auditEntityId <= 0)
                    return Results.BadRequest("auditEntityType and auditEntityId are required.");

                var result = await service.IsDraftAsync(auditEntityType, auditEntityId, cancellationToken)
                    .ConfigureAwait(false);
                return Results.Ok(new { isDraft = result });
            });

            // ================================================================
            // SAVE / UPDATE
            // ================================================================

            group.MapPost("/", async (
                [FromBody] IQASignatoryDto dto,
                IIQAAuditSignatoryService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null) return Results.BadRequest("Request body is required.");

                var saved = await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_iqaSignatory, cancellationToken).ConfigureAwait(false);

                return Results.Ok(saved);
            });

            // ================================================================
            // APPROVAL WORKFLOW
            // ================================================================

            // SUBMIT FOR APPROVAL — creates one Pending IQASignatory row per
            // active template for this audit entity type.
            group.MapPost("/submit", async (
                [FromBody] SubmitForApprovalRequest request,
                IIQAAuditSignatoryService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (request == null) return Results.BadRequest("Request body is required.");

                var success = await service.SubmitForApprovalAsync(
                    request.AuditEntityType, request.AuditEntityId, request.UserId, cancellationToken)
                    .ConfigureAwait(false);

                if (!success) return Results.BadRequest("Unable to submit for approval.");

                await cache.EvictByTagAsync(_iqaSignatory, cancellationToken).ConfigureAwait(false);
                return Results.Ok(new { message = "Submitted for approval." });
            });

            // APPROVE OR DISAPPROVE — a disapproval resets the whole chain
            // (handled inside the service via ResetOnDisapprovalAsync).
            group.MapPost("/decide", async (
                [FromBody] ApproveOrDisapproveRequest request,
                IIQAAuditSignatoryService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (request == null) return Results.BadRequest("Request body is required.");

                var success = await service.ApproveOrDisapproveAsync(
                    request.AuditEntityType,
                    request.AuditEntityId,
                    request.SignatoryId,
                    request.Approve,
                    request.Remarks,
                    cancellationToken)
                    .ConfigureAwait(false);

                if (!success) return Results.NotFound(new { message = "No pending signatory found for this signatory ID." });

                await cache.EvictByTagAsync(_iqaSignatory, cancellationToken).ConfigureAwait(false);
                return Results.Ok(new { message = request.Approve ? "Approved." : "Disapproved — approval chain reset." });
            });

            // RESET ON DISAPPROVAL — soft-deletes every signatory row for
            // this audit entity, exposed directly in case a caller needs to
            // force a reset outside of the decide flow.
            group.MapPost("/reset", async (
                [FromBody] ResetOnDisapprovalRequest request,
                IIQAAuditSignatoryService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (request == null) return Results.BadRequest("Request body is required.");

                var success = await service.ResetOnDisapprovalAsync(
                    request.AuditEntityType, request.AuditEntityId, cancellationToken)
                    .ConfigureAwait(false);

                await cache.EvictByTagAsync(_iqaSignatory, cancellationToken).ConfigureAwait(false);
                return success ? Results.Ok(new { message = "Approval chain reset." }) : Results.NotFound();
            });
        }
    }
}