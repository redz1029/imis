using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditChecklistModule;
using IMIS.Application.AuditReportModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System.Threading;

namespace IMIS.Presentation.AuditReportModule
{
    public class AuditReportEndPoints : CarterModule
    {
        private const string _auditReport = "Audit Report";
        public readonly AuditReportPermission _permission = new();

        public AuditReportEndPoints() : base("/auditreport")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE — reports are raised by saving the audit checklist, never by hand.
            app.MapPost("/", async ([FromBody] AuditReportDto dto, IAuditReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (dto.Id == 0)
                    return Results.BadRequest("Audit reports are created automatically when the audit checklist is saved.");

                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditReport, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditReport)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // UPDATE — purpose, conclusions and commendable findings only.
            app.MapPut("/", async ([FromBody] AuditReportDto dto, IAuditReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (dto.Id == 0)
                    return Results.BadRequest("Audit reports are created automatically when the audit checklist is saved.");

                try
                {
                    await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                }
                catch (InvalidOperationException ex)
                {
                    return Results.BadRequest(ex.Message);
                }

                await cache.EvictByTagAsync(_auditReport, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditReport)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // BACKFILL — raises the report of every schedule whose checklist was
            // saved before reports were automatic. Idempotent; leaves existing
            // reports untouched.
            app.MapPost("/sync-from-checklists", async (IAuditChecklistService checklists, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var created = await checklists.SyncMissingAuditReportsAsync(cancellationToken).ConfigureAwait(false);
                if (created > 0) await cache.EvictByTagAsync(_auditReport, cancellationToken);
                return Results.Ok(new { created });
            })
            .WithTags(_auditReport)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // CHECKLIST FIGURES — conforming / non-conforming / NCAR counts per
            // schedule, for the report list.
            app.MapGet("/findings-summary", async (IAuditReportService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetFindingsSummariesAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditReport)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET BY ID
            app.MapGet("/{id:int}", async (int id, IAuditReportService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_auditReport)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // CLAUSE RESULTS — every checklist result of the report's schedule,
            // with the NCAR raised for each non-conforming clause.
            app.MapGet("/schedule/{auditScheduleId:int}/clause-results", async (int auditScheduleId, IAuditReportService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetClauseResultsAsync(auditScheduleId, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditReport)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET PAGINATED
            app.MapGet("/page", async (int page, int pageSize, IAuditReportService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditReport)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // SOFT DELETE
            app.MapDelete("/{id:int}", async (int id, IAuditReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_auditReport, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_auditReport)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
        }
    }
}