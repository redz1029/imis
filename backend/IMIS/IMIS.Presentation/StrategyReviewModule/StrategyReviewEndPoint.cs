using Base.Auths.Permissions;
using Carter;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.StrategyReviewModule;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.StrategyReviewModule
{
    public class StrategyReviewEndPoint : CarterModule
    {
        private const string _strategyReview = "Strategy Review";
        public readonly StrategyReviewPermission _strategyReviewPermission = new();
        public StrategyReviewEndPoint() : base("/strategyReview")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] StrategyReviewDto dto, IStrategyReviewService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_strategyReview, cancellationToken);
                return Results.Ok(dto);
            })
           .WithTags(_strategyReview)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategyReviewPermission.Add));
            
            app.MapGet("/{id:long}", async (long id, IStrategyReviewService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);

                if (result == null)
                    return Results.NotFound();
                return Results.Ok(result);
            })
           .WithTags(_strategyReview)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_strategyReview), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategyReviewPermission.View));

            app.MapGet("/pdf/{id:long}", async (long id, IStrategyReviewService service, HttpResponse response, CancellationToken cancellationToken) =>
            {
                var operationReviewProtocolReport = await service.ReportGetByIdAsync(id, cancellationToken);

                if (operationReviewProtocolReport == null)
                    return Results.NotFound();

                var file = await ReportUtil.GeneratePdfReport<ReportStrategyReviewDto>("StrategyReviewReport",
                    new List<ReportStrategyReviewDto>
                    {
                        operationReviewProtocolReport
                    },
                    "StrategyReview", cancellationToken).ConfigureAwait(false);

                // FORCE INLINE PDF VIEW IN BROWSER
                var fileName = $"ReportPerfomanceGovernanceSystem_{DateTime.Now:yyyyMMddHHmmss}.pdf";
                response.Headers.ContentDisposition = $"inline; filename={fileName}";
                return Results.File(file, "application/pdf");

                //return Results.File(file, "application/pdf", $"StrategyReview_{DateTime.Now:yyyyMMddHHmmss}.pdf");

                //var result = await service.ReportGetByIdAsync(id, pgsId, month, year, cancellationToken).ConfigureAwait(false);
                //return result != null ? Results.Ok(result) : Results.NotFound();

                //var result = await service.ReportGetByIdAsync(id, cancellationToken);

                //if (result == null)
                //    return Results.NotFound();
                //return Results.Ok(result);
            })
           .WithTags(_strategyReview)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_strategyReview), true);

            app.MapPut("/update", async ([FromBody] StrategyReviewDto dto, IStrategyReviewService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_strategyReview, cancellationToken);
                return Results.Ok(dto);
            })
           .WithTags(_strategyReview)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategyReviewPermission.Edit));

            app.MapGet("/deliverables/{kraRoadMapId:long}/{year:int}", async (long kraRoadMapId, int year, IKraRoadMapDeliverableService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByRoadMapIdAsync(kraRoadMapId, year, cancellationToken);

                return Results.Ok(result);
            })
            .WithTags(_strategyReview)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_strategyReview), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategyReviewPermission.View));

            app.MapGet("/kpis/{kraRoadMapId:long}/{year:int}", async (long kraRoadMapId, int year,  IKraRoadMapKpiService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetKpiByRoadMapIdAsync(kraRoadMapId, year, cancellationToken);

                return Results.Ok(result);
            })  
            .WithTags(_strategyReview)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_strategyReview), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategyReviewPermission.View));

            app.MapGet("/roleid/{roleId}", async (string roleId, int? strategyReviewPeriodId, int page, int pageSize, IStrategyReviewService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllRoleIdAsync(roleId, strategyReviewPeriodId, page, pageSize, cancellationToken);

                return Results.Ok(result);
            })
            .WithTags(_strategyReview)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_strategyReview), true);

            app.MapDelete("/{id:int}", async (int id, IStrategyReviewService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_strategyReview, cancellationToken);

                return result ? Results.Ok(new { message = " Review deleted successfully." }) : Results.NotFound(new { message = "Review not found." });
            })
           .WithTags(_strategyReview)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategyReviewPermission.Edit));
        }
    }
}
