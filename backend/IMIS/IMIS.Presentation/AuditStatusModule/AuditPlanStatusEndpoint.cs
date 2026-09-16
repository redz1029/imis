using Carter;
using IMIS.Application.AuditStatusModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System.Threading;

namespace IMIS.Presentation.AuditStatusModule
{
    public class AuditPlanStatusEndPoints : CarterModule
    {
        private const string _auditStatus = "Audit Status";

        public AuditPlanStatusEndPoints() : base("/auditstatus")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] AuditPlanStatusDto dto, IAuditPlanStatusService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditStatus, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditStatus);

            app.MapPut("/", async ([FromBody] AuditPlanStatusDto dto, IAuditPlanStatusService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditStatus, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditStatus);

            app.MapGet("/", async (IAuditPlanStatusService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditStatus)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(10)).Tag(_auditStatus), true);

            app.MapGet("/page", async (int page, int pageSize, IAuditPlanStatusService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditStatus)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(10)).Tag(_auditStatus), true);
            app.MapDelete("/{id:int}", async (int id, IAuditPlanStatusService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var (success, error) = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_auditStatus, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_auditStatus);
        }
    }
}