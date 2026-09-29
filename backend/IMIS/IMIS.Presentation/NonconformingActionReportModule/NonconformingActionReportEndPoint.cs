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
            .WithTags(_ncarTag);

            // UPDATE
            app.MapPut("/", async ([FromBody] NonconformingActionReportDto dto, INonconformingActionReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_ncarTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_ncarTag);

            // GET BY ID
            app.MapGet("/{id:long}", async (long id, INonconformingActionReportService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_ncarTag);

            // GET PAGINATED
            app.MapGet("/page", async (int page, int pageSize, INonconformingActionReportService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_ncarTag);

            // CREATE FROM AUDIT REPORT (auto-fetch findings)
            app.MapPost("/from-audit-report/{auditReportId:int}", async (int auditReportId, [FromQuery] string issuedByAuditorUserId, [FromQuery] string acknowledgedByAuditeeUserId, INonconformingActionReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.CreateFromAuditReportAsync(auditReportId, issuedByAuditorUserId, acknowledgedByAuditeeUserId, cancellationToken).ConfigureAwait(false);
                if (result is null) return Results.NotFound($"Audit Report with ID {auditReportId} not found.");

                await cache.EvictByTagAsync(_ncarTag, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_ncarTag);

            // SOFT DELETE
            app.MapDelete("/{id:long}", async (long id, INonconformingActionReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_ncarTag, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_ncarTag);
        }
    }
}
