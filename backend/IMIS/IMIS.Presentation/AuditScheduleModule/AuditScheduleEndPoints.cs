using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditScheduleModule;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Presentation.AuditScheduleModule
{
    public class AuditScheduleEndPoints : CarterModule
    {
        private const string _AuditSchedule = "AuditSchedule";

        // The plan list embeds each plan's schedules (and the status derived from
        // them) and the checklist list is built from the schedules, so a schedule
        // write must also drop those cached lists or they show stale data for up
        // to 2 minutes. Must match the tags in AuditPlanEndpoint / AuditChecklistEndpoint.
        private const string _relatedPlanTag = "AuditPlan";
        private const string _relatedChecklistTag = "Audit Checklist";
        // Assuming AuditSchedulePermission exists following your naming convention
        public readonly AuditSchedulePermission _permission = new();
        public readonly AuditScheduleWorkflowPermission _workflowPermission = new();

        public AuditScheduleEndPoints() : base("/auditSchedule")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async (
                [FromBody] AuditScheduleDto dto,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                HttpContext httpContext,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                // Actor for the workflow rows (history + signatory slots).
                // Must be a real AspNetUsers id — placeholders violate the FK.
                var actorUserId = httpContext.User.FindFirst("UserId")?.Value;
                var result = await service.SaveAuditScheduleAsync(dto, cancellationToken, actorUserId);

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                await cache.EvictByTagAsync(_relatedPlanTag, cancellationToken);

                await cache.EvictByTagAsync(_relatedChecklistTag, cancellationToken);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to save Audit Schedule.");
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // GET ALL
            app.MapGet("/", async (
                IAuditScheduleService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditSchedule)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET CONFIRMED ONLY (Workflow Gate for Audit Checklist)//
            app.MapGet("/confirmed", async (
                IAuditScheduleService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetConfirmedAsync(cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditSchedule)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET BY PLAN ID
            app.MapGet("/plan/{auditPlanId:int}", async (
                int auditPlanId,
                IAuditScheduleService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByAuditPlanIdAsync(auditPlanId, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditSchedule)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET BY ID
            app.MapGet("/{id:int}", async (
                int id,
                IAuditScheduleService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);

                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_AuditSchedule)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // UPDATE
            app.MapPut("/{id:int}", async (
                int id,
                [FromBody] AuditScheduleDto dto,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                dto.Id = id;

                var result = await service.SaveAuditScheduleAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                await cache.EvictByTagAsync(_relatedPlanTag, cancellationToken);

                await cache.EvictByTagAsync(_relatedChecklistTag, cancellationToken);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to update Audit Schedule.");
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // PAGINATION
            app.MapGet("/page", async (
                int page,
                int pageSize,
                IAuditScheduleService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditSchedule)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));
            // GENERATE PDF REPORT
            app.MapGet("/PdF/{id:int}", async (
                HttpResponse response,
                int id,
                IAuditScheduleService service,
                CancellationToken cancellationToken) =>
            {
                var auditData = await service.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);

                if (auditData == null)
                    return Results.NotFound(new { message = $"Audit Schedule with ID {id} was not found." });

                var file = await ReportUtil.GeneratePdfReport<ReportAuditScheduleDto>(
                    "AuditSchedule",
                    new List<ReportAuditScheduleDto> { auditData },
                    "ScheduleData",
                    cancellationToken
                ).ConfigureAwait(false);

                return Results.File(file, "application/pdf", $"AuditSchedule_{DateTime.Now:yyyyMMddHHmmss}.pdf");
            })
            .WithTags(_AuditSchedule)
            .RequireCors("_allowedOrigins")
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));


            // DELETE (SOFT DELETE)
            app.MapDelete("/{id:int}", async (
                int id,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                await cache.EvictByTagAsync(_relatedPlanTag, cancellationToken);

                await cache.EvictByTagAsync(_relatedChecklistTag, cancellationToken);

                return result
                    ? Results.Ok(new { message = "Audit Schedule deleted successfully." })
                    : Results.NotFound(new { message = "Audit Schedule not found." });
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // SUBMIT — Draft/Rejected -> Pending Confirmation (Auditor Team Leader)
            app.MapPut("/{id:int}/submit", async (
                int id,
                [FromBody] SubmitAuditScheduleRequest? body,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var (success, error) = await service.SubmitAsync(id, body?.UserId, body?.Comments, cancellationToken);

                if (!success)
                    return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                await cache.EvictByTagAsync(_relatedPlanTag, cancellationToken);

                await cache.EvictByTagAsync(_relatedChecklistTag, cancellationToken);
                return Results.Ok(new { message = "Submitted for confirmation." });
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _workflowPermission.CanSubmit));

            // DECIDE — Pending -> Confirmed/Rejected (Department Head)
            app.MapPut("/{id:int}/decide", async (
                int id,
                [FromBody] DecideAuditScheduleRequest dto,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto is null)
                    return Results.BadRequest("Invalid request.");

                string action = !string.IsNullOrWhiteSpace(dto.Action)
                    ? dto.Action
                    : ((dto.Approve ?? false) ? "Confirm" : "Reject");

                var (success, error) = await service.DecideAsync(
                    id, dto.ApproverId, action, dto.Comments, dto.OfficeName, cancellationToken
                );

                if (!success)
                    return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                await cache.EvictByTagAsync(_relatedPlanTag, cancellationToken);

                await cache.EvictByTagAsync(_relatedChecklistTag, cancellationToken);
                return Results.Ok(new { message = action == "Reject" ? "Rejected." : $"{action}ed." });
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireAssertion(ctx =>
                ctx.User.HasClaim(PermissionClaimType.Claim, _workflowPermission.CanConfirm) ||
                ctx.User.HasClaim(PermissionClaimType.Claim, _workflowPermission.CanReject)));

            // RESCHEDULE REQUEST — Department Head asks to move the schedule. Goes to
            // the Auditor Team Leader first, then the Lead Auditor.
            app.MapPost("/{id:int}/reschedule-request", async (
                int id,
                [FromBody] RescheduleRequestBody? body,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                HttpContext httpContext,
                CancellationToken cancellationToken) =>
            {
                if (body == null || !body.ProposedStart.HasValue)
                    return Results.BadRequest(new { error = "Proposed date and time are required." });

                var userId = httpContext.User.FindFirst("UserId")?.Value;
                var (success, error) = await service.RequestRescheduleAsync(
                    id, body.ProposedStart.Value, body.Reason, userId, cancellationToken);

                if (!success)
                    return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                await cache.EvictByTagAsync(_relatedPlanTag, cancellationToken);

                await cache.EvictByTagAsync(_relatedChecklistTag, cancellationToken);
                return Results.Ok(new { message = "Reschedule request sent to the Auditor Team Leader." });
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireAssertion(ctx =>
                ctx.User.HasClaim(PermissionClaimType.Claim, _workflowPermission.CanConfirm) ||
                ctx.User.HasClaim(PermissionClaimType.Claim, _workflowPermission.CanReject)));

            // Latest reschedule request of one schedule.
            app.MapGet("/{id:int}/reschedule-request", async (
                int id,
                IAuditScheduleService service,
                HttpContext httpContext,
                CancellationToken cancellationToken) =>
            {
                var userId = httpContext.User.FindFirst("UserId")?.Value;
                var result = await service.GetLatestRescheduleRequestAsync(id, userId, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization();

            // Every reschedule request still waiting on an approver (status badges
            // on the schedule list).
            app.MapGet("/reschedule-requests/open", async (
                IAuditScheduleService service,
                HttpContext httpContext,
                CancellationToken cancellationToken) =>
            {
                var userId = httpContext.User.FindFirst("UserId")?.Value;
                var result = await service.GetOpenRescheduleRequestsAsync(userId, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization();

            // Reschedule requests waiting on the signed-in user (notifications).
            app.MapGet("/reschedule-requests/pending", async (
                IAuditScheduleService service,
                HttpContext httpContext,
                CancellationToken cancellationToken) =>
            {
                var userId = httpContext.User.FindFirst("UserId")?.Value;
                var result = await service.GetPendingRescheduleRequestsAsync(userId, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization();

            // Team Leader / Lead Auditor decision on a reschedule request.
            app.MapPut("/reschedule-requests/{requestId:int}/decide", async (
                int requestId,
                [FromBody] RescheduleDecisionBody? body,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                HttpContext httpContext,
                CancellationToken cancellationToken) =>
            {
                if (body == null)
                    return Results.BadRequest(new { error = "Invalid request." });

                var userId = httpContext.User.FindFirst("UserId")?.Value;
                var (success, error) = await service.DecideRescheduleRequestAsync(
                    requestId, userId, body.Approve, body.Remarks, cancellationToken);

                if (!success)
                    return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                await cache.EvictByTagAsync(_relatedPlanTag, cancellationToken);

                await cache.EvictByTagAsync(_relatedChecklistTag, cancellationToken);
                return Results.Ok(new { message = body.Approve ? "Approved." : "Rejected." });
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization();

            // RESCHEDULE — preparer picks a new date; time stays locked to the
            // linked audit plan entry. Same-day same-time conflicts for the same
            // auditee office are rejected.
            app.MapPut("/{id:int}/reschedule", async (
                int id,
                [FromBody] RescheduleAuditScheduleRequest? body,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (body == null || !body.ProposedDate.HasValue)
                    return Results.BadRequest("Proposed date is required.");

                var (success, error) = await service.RescheduleAsync(
                    id, body.ProposedDate.Value, body.Comments, cancellationToken);

                if (!success)
                    return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                await cache.EvictByTagAsync(_relatedPlanTag, cancellationToken);

                await cache.EvictByTagAsync(_relatedChecklistTag, cancellationToken);
                return Results.Ok(new { message = "Audit schedule rescheduled." });
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _workflowPermission.CanSubmit));

        }

        public record RescheduleRequestBody(DateTime? ProposedStart, string? Reason);
        public record RescheduleDecisionBody(bool Approve, string? Remarks);
        public record SubmitAuditScheduleRequest(string? UserId, string? Comments);
        public record DecideAuditScheduleRequest(string ApproverId, bool? Approve, string? Action, string? Comments, string? OfficeName);
        public record RescheduleAuditScheduleRequest(DateTime? ProposedDate, string? Comments);
    }
}