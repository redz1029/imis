using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditComFindingsModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System.Threading;

namespace IMIS.Presentation.AuditComFindingsModule
{
    public class AuditComFindingsEndPoints : CarterModule
    {
        private const string _auditComFindings = "Audit Commendable Findings";

        public AuditComFindingsEndPoints() : base("/auditcomfindings")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async ([FromBody] AuditComFindingsDto dto, IAuditComFindingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditComFindings, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditComFindings);

            // UPDATE
            app.MapPut("/", async ([FromBody] AuditComFindingsDto dto, IAuditComFindingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditComFindings, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditComFindings);

            // GET BY ID
            app.MapGet("/{id:int}", async (int id, IAuditComFindingsService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_auditComFindings);

            // GET PAGINATED
            app.MapGet("/page", async (int page, int pageSize, IAuditComFindingsService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditComFindings);

            // SOFT DELETE
            app.MapDelete("/{id:int}", async (int id, IAuditComFindingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_auditComFindings, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_auditComFindings);
        }
    }
}