using Base.Auths.Permissions;
using Carter;
using IMIS.Application.NonconformingActionReportModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using System.Threading;

namespace IMIS.Presentation.NonconformingActionReportModule
{
    public class NonconformingActionReportEndPoints : CarterModule
    {
        private const string _ncarTag = "Nonconforming Action Report";
        public readonly NonconformingActionReportPermission _permission = new();
        public readonly NonconformingActionReportWorkflowPermission _workflowPermission = new();

        public NonconformingActionReportEndPoints() : base("/ncar")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async ([FromBody] NonconformingActionReportDto dto, INonconformingActionReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_ncarTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_ncarTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // UPDATE
            app.MapPut("/", async ([FromBody] NonconformingActionReportDto dto, INonconformingActionReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_ncarTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_ncarTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // GET BY ID
            app.MapGet("/{id:long}", async (long id, INonconformingActionReportService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_ncarTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET PAGINATED
            app.MapGet("/page", async (int page, int pageSize, INonconformingActionReportService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_ncarTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // CREATE FROM AUDIT REPORT (auto-fetch findings for the chosen status)
            app.MapPost("/from-audit-report/{auditReportId:int}", async (int auditReportId, [FromQuery] string status, [FromQuery] string issuedByAuditorUserId, [FromQuery] string acknowledgedByAuditeeUserId, INonconformingActionReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.CreateFromAuditReportAsync(auditReportId, status, issuedByAuditorUserId, acknowledgedByAuditeeUserId, cancellationToken).ConfigureAwait(false);
                if (result is null) return Results.NotFound($"No findings with status '{status}' to raise an NCAR for audit report {auditReportId}, or the report does not exist.");

                await cache.EvictByTagAsync(_ncarTag, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_ncarTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // CHANGE STATUS — PendingVerification -> Active -> Closed
            app.MapPut("/{id:long}/status", async (
                long id,
                [FromBody] ChangeNcarStatusRequest dto,
                INonconformingActionReportService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto is null || string.IsNullOrWhiteSpace(dto.Status))
                    return Results.BadRequest("Status is required.");

                var (success, error) = await service.ChangeStatusAsync(id, dto.Status, dto.Comments, cancellationToken)
                    .ConfigureAwait(false);

                if (!success)
                    return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_ncarTag, cancellationToken);
                return Results.Ok(new { message = $"NCAR status changed to {dto.Status}." });
            })
            .WithTags(_ncarTag)
            .RequireAuthorization(e => e.RequireAssertion(ctx =>
                ctx.User.HasClaim(PermissionClaimType.Claim, _workflowPermission.CanVerify) ||
                ctx.User.HasClaim(PermissionClaimType.Claim, _workflowPermission.CanValidateAndClose)));

            // SOFT DELETE
            app.MapDelete("/{id:long}", async (long id, INonconformingActionReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_ncarTag, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_ncarTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
        }

        public record ChangeNcarStatusRequest(string Status, string? Comments);
    }
}
