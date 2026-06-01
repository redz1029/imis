using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditSummaryFindingsModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System.Threading;

namespace IMIS.Presentation.AuditSummaryFindingsModule
{
    public class AuditSummaryFindingsEndPoints : CarterModule
    {
        private const string _auditSummaryFindings = "Audit Summary Findings";

        public AuditSummaryFindingsEndPoints() : base("/auditsummaryfindings")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async ([FromBody] AuditSummaryFindingsDto dto, IAuditSummaryFindingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditSummaryFindings, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditSummaryFindings);

            // UPDATE
            app.MapPut("/", async ([FromBody] AuditSummaryFindingsDto dto, IAuditSummaryFindingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditSummaryFindings, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditSummaryFindings);

            // GET BY ID
            app.MapGet("/{id:int}", async (int id, IAuditSummaryFindingsService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_auditSummaryFindings);

            // GET PAGINATED
            app.MapGet("/page", async (int page, int pageSize, IAuditSummaryFindingsService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditSummaryFindings);

            // SOFT DELETE
            app.MapDelete("/{id:int}", async (int id, IAuditSummaryFindingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_auditSummaryFindings, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_auditSummaryFindings);
        }
    }
}