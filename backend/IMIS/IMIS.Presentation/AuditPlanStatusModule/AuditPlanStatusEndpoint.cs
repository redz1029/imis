using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditPlanStatusModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditPlanStatusModule
{
    public class AuditPlanStatusEndPoints : CarterModule
    {
        private const string _auditPlanStatus = "Audit Plan Status";

        public AuditPlanStatusEndPoints() : base("/auditplanstatus")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] AuditPlanStatusDTO auditPlanStatusDto, IAuditPlanStatusService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(auditPlanStatusDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditPlanStatus, cancellationToken);
                return Results.Ok(auditPlanStatusDto);
            })
            .WithTags(_auditPlanStatus);

            app.MapPut("/", async ([FromBody] AuditPlanStatusDTO auditPlanStatusDto, IAuditPlanStatusService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(auditPlanStatusDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditPlanStatus, cancellationToken);
                return Results.Ok(auditPlanStatusDto);
            })
            .WithTags(_auditPlanStatus);

            app.MapGet("/", async (IAuditPlanStatusService service, CancellationToken cancellationToken) =>
            {
                var auditPlanStatusDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(auditPlanStatusDto);
            })
            .WithTags(_auditPlanStatus);

            app.MapGet("/page", async (int page, int pageSize, IAuditPlanStatusService service, CancellationToken cancellationToken) =>
            {
                var auditPlanStatusDtos = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(auditPlanStatusDtos);
            })
            .WithTags(_auditPlanStatus);
        }
    }
}