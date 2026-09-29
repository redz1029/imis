using Carter;
using IMIS.Application.NcarMonitoringLogModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using System;
using System.Threading;

namespace IMIS.Presentation.NcarMonitoringLogModule
{
    public class NcarMonitoringEndpoint : CarterModule
    {
        private const string _ncarMonitoringTag = "NCAR Monitoring Log";

        public NcarMonitoringEndpoint() : base("/api/NcarMonitoring")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // GET PAGINATED (default overdue-priority sorting applied)
            app.MapGet("/paginated", async (int page, int pageSize, INcarMonitoringLogService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_ncarMonitoringTag);

            // GET BY ID
            app.MapGet("/{id:long}", async (long id, INcarMonitoringLogService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_ncarMonitoringTag);

            // SYNC FROM NCAR (auto create/update)
            app.MapPost("/sync/{nonconformingActionReportId:long}", async (long nonconformingActionReportId,
                [FromBody] SyncNcarMonitoringRequest request, INcarMonitoringLogService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SyncFromNcarAsync(nonconformingActionReportId, request.DeptSectionUnit, request.DateIssued,
                    request.IssuedByName, request.ItemNoRelevantStandard, request.AuditeeName, cancellationToken).ConfigureAwait(false);

                await cache.EvictByTagAsync(_ncarMonitoringTag, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_ncarMonitoringTag);

            // UPDATE VERIFICATION
            app.MapPut("/{id:long}/verify", async (long id, [FromBody] VerifyNcarMonitoringRequest request, INcarMonitoringLogService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.UpdateVerificationAsync(id, request.DateVerified, request.VerifiedByAuditorName, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_ncarMonitoringTag, cancellationToken);
                return Results.Ok(new { Message = "Verified Successfully" });
            })
            .WithTags(_ncarMonitoringTag);

            // UPDATE VALIDATION (closes the NCAR)
            app.MapPut("/{id:long}/validate", async (long id, [FromBody] ValidateNcarMonitoringRequest request, INcarMonitoringLogService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.UpdateValidationAsync(id, request.DateValidated, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_ncarMonitoringTag, cancellationToken);
                return Results.Ok(new { Message = "Validated and Closed Successfully" });
            })
            .WithTags(_ncarMonitoringTag);

            // SOFT DELETE
            app.MapDelete("/{id:long}", async (long id, INcarMonitoringLogService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_ncarMonitoringTag, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_ncarMonitoringTag);
        }
    }

    public record SyncNcarMonitoringRequest(string DeptSectionUnit, DateTime DateIssued, string IssuedByName, string ItemNoRelevantStandard, string AuditeeName);
    public record VerifyNcarMonitoringRequest(DateTime DateVerified, string VerifiedByAuditorName);
    public record ValidateNcarMonitoringRequest(DateTime DateValidated);
}
