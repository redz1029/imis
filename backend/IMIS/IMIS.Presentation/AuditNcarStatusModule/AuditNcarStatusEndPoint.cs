using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditNcarStatusModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System.Threading;

namespace IMIS.Presentation.AuditNcarStatusModule
{
    public class AuditNcarStatusEndPoints : CarterModule
    {
        private const string _auditNcarStatus = "Audit NCAR Status";

        public AuditNcarStatusEndPoints() : base("/auditncarstatus")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async ([FromBody] AuditNcarStatusDto dto, IAuditNcarStatusService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditNcarStatus, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditNcarStatus);

            // UPDATE
            app.MapPut("/", async ([FromBody] AuditNcarStatusDto dto, IAuditNcarStatusService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditNcarStatus, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditNcarStatus);

            // GET BY ID
            app.MapGet("/{id:int}", async (int id, IAuditNcarStatusService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_auditNcarStatus);

            // GET PAGINATED
            app.MapGet("/page", async (int page, int pageSize, IAuditNcarStatusService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditNcarStatus);

            // SOFT DELETE
            app.MapDelete("/{id:int}", async (int id, IAuditNcarStatusService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_auditNcarStatus, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_auditNcarStatus);
        }
    }
}