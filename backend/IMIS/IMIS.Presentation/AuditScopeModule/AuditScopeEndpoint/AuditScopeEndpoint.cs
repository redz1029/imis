using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditScopeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System.Threading;

namespace IMIS.Presentation.AuditScopeModule
{
    public class AuditScopeEndPoints : CarterModule
    {
        private const string _auditScope = "Audit Scope";

        public AuditScopeEndPoints() : base("/auditscope")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async ([FromBody] AuditScopeDto dto, IAuditScopeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditScope, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditScope);

            // UPDATE
            app.MapPut("/", async ([FromBody] AuditScopeDto dto, IAuditScopeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditScope, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditScope);

            // GET BY ID
            app.MapGet("/{id:int}", async (int id, IAuditScopeService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_auditScope);

            // GET PAGINATED
            app.MapGet("/page", async (int page, int pageSize, IAuditScopeService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditScope);

            // SOFT DELETE
            app.MapDelete("/{id:int}", async (int id, IAuditScopeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_auditScope, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_auditScope);
        }
    }
}