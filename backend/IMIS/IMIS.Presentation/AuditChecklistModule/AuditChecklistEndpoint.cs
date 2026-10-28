using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditChecklistModule;
using IMIS.Domain;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System.Collections.Generic;

namespace IMIS.Presentation.AuditChecklistModule
{
    public class AuditChecklistEndPoints : CarterModule
    {
        private const string _auditChecklist = "Audit Checklist";
        public readonly AuditChecklistPermission _permission = new();

        public AuditChecklistEndPoints() : base("/auditchecklist")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE / UPDATE
            app.MapPost("/", async ([FromBody] AuditChecklistDto dto, IAuditChecklistService service, IOutputCacheStore cache, HttpContext httpContext, CancellationToken cancellationToken) =>
            {
                var userId = httpContext.User.FindFirst("UserId")?.Value;
                var (success, error) = await service.SaveChecklistForUserAsync(dto, userId, cancellationToken).ConfigureAwait(false);
                if (!success)
                    return Results.Json(new { error }, statusCode: StatusCodes.Status403Forbidden);

                await cache.EvictByTagAsync(_auditChecklist, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // UPDATE (Matches POST logic in your template)
            app.MapPut("/", async ([FromBody] AuditChecklistDto dto, IAuditChecklistService service, IOutputCacheStore cache, HttpContext httpContext, CancellationToken cancellationToken) =>
            {
                var userId = httpContext.User.FindFirst("UserId")?.Value;
                var (success, error) = await service.SaveChecklistForUserAsync(dto, userId, cancellationToken).ConfigureAwait(false);
                if (!success)
                    return Results.Json(new { error }, statusCode: StatusCodes.Status403Forbidden);

                await cache.EvictByTagAsync(_auditChecklist, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
            // GET OR GENERATE FROM AUDIT PLAN ENTRY
            app.MapGet("/planentry/{auditPlanEntryId:int}", async (int auditPlanEntryId, IAuditChecklistService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetOrGenerateForAuditPlanEntryAsync(auditPlanEntryId, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditChecklist), true);

            // GET OR GENERATE FROM AUDIT SCHEDULE — the ONLY reliable key for
            // the checklist flow. Preserves existing rows (never duplicates).
            app.MapGet("/schedule/{auditScheduleId:int}", async (int auditScheduleId, IAuditChecklistService service, HttpContext httpContext, CancellationToken cancellationToken) =>
            {
                try
                {
                    var userId = httpContext.User.FindFirst("UserId")?.Value;
                    var result = await service.GetOrGenerateForAuditScheduleAsync(auditScheduleId, cancellationToken, userId).ConfigureAwait(false);
                    return Results.Ok(result);
                }
                catch (KeyNotFoundException)
                {
                    return Results.NotFound(new { message = "Audit schedule not found." });
                }
                catch (InvalidOperationException ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // CLAUSE ASSIGNMENT BOARD — the Team Leader divides the plan clauses
            // among the team's auditors; an auditor only gets their own clauses.
            app.MapGet("/schedule/{auditScheduleId:int}/assignments", async (int auditScheduleId, IAuditChecklistService service, HttpContext httpContext, CancellationToken cancellationToken) =>
            {
                try
                {
                    var userId = httpContext.User.FindFirst("UserId")?.Value;
                    var result = await service.GetAssignmentsAsync(auditScheduleId, userId, cancellationToken).ConfigureAwait(false);
                    return Results.Ok(result);
                }
                catch (KeyNotFoundException)
                {
                    return Results.NotFound(new { message = "Audit schedule not found." });
                }
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            app.MapPut("/schedule/{auditScheduleId:int}/assignments", async (int auditScheduleId, [FromBody] List<AuditChecklistAssignmentRequestItem>? body, IAuditChecklistService service, IOutputCacheStore cache, HttpContext httpContext, CancellationToken cancellationToken) =>
            {
                var userId = httpContext.User.FindFirst("UserId")?.Value;
                var (success, error) = await service.AssignClausesAsync(auditScheduleId, body ?? new List<AuditChecklistAssignmentRequestItem>(), userId, cancellationToken).ConfigureAwait(false);
                if (!success)
                    return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_auditChecklist, cancellationToken);
                return Results.Ok(new { message = "Clause assignments saved." });
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // DYNAMIC CHECKLIST LIST — schedules ordered by schedule Id, each
            // with team name + office/process. Backs the team-list page.
            app.MapGet("/schedules", async (IAuditChecklistService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetSchedulesWithChecklistDataAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditChecklist), true);

            // GET BY ID
            app.MapGet("/{id:int}", async (int id, IAuditChecklistService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))

            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_auditChecklist), true);

            // GET BY PROCESS ID
            app.MapGet("/process/{processId:int}", async (int processId, IAuditChecklistService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByProcessIdAsync(processId, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditChecklist), true);

            // PAGINATED
            app.MapGet("/page", async (int page, int pageSize, IAuditChecklistService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditChecklist), true);

            // DELETE
            app.MapDelete("/{id:int}", async (int id, IAuditChecklistService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_auditChecklist, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
            // GENERATE PDF REPORT — one PDF per AuditSchedule (all its checklist rows)
            app.MapGet("/PdF/schedule/{auditScheduleId:int}", async (
                HttpResponse response,
                int auditScheduleId,
                IAuditChecklistService service,
                CancellationToken cancellationToken) =>
            {
                var auditData = await service.ReportGetByAuditScheduleIdAsync(auditScheduleId, cancellationToken).ConfigureAwait(false);

                if (auditData == null)
                    return Results.NotFound(new { message = $"No checklist rows found for Audit Schedule {auditScheduleId}." });

                var file = await ReportUtil.GeneratePdfReport<ReportAuditChecklistDto>(
                    "AuditChecklist",
                    new List<ReportAuditChecklistDto> { auditData },
                    "ChecklistData",
                    cancellationToken
                ).ConfigureAwait(false);

                return Results.File(file, "application/pdf", $"AuditChecklist_{DateTime.Now:yyyyMMddHHmmss}.pdf");
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditChecklist), true);
            // GET BY AUDITEE ID
            app.MapGet("/auditee/{auditeeId:int}", async (int auditeeId, IAuditChecklistService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByAuditeeIdAsync(auditeeId, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditChecklist)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditChecklist), true);
        }
    }
}
