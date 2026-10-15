using Base.Auths.Permissions;
using Carter;
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

        public AuditReportEndPoints() : base("/auditreport")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async ([FromBody] AuditReportDto dto, IAuditReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditReport, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditReport);

            // UPDATE
            app.MapPut("/", async ([FromBody] AuditReportDto dto, IAuditReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditReport, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditReport);

            // GET BY ID
            app.MapGet("/{id:int}", async (int id, IAuditReportService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_auditReport);

            // GET PAGINATED
            app.MapGet("/page", async (int page, int pageSize, IAuditReportService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditReport);

            // SOFT DELETE
            app.MapDelete("/{id:int}", async (int id, IAuditReportService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_auditReport, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_auditReport);
        }
    }
}