using Base.Auths.Permissions;
using Carter;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.StrategyReviewModule;
using IMIS.Domain;
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

            app.MapGet("/", async (IStrategyReviewService service, CancellationToken cancellationToken) =>
            {
                var kraRoadMapDto = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(kraRoadMapDto);
            })
            .WithTags(_strategyReview)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_strategyReview), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategyReviewPermission.View));

            app.MapGet("/{id:long}", async (long id, IStrategyReviewService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);

                if (result == null)
                    return Results.NotFound();
                return Results.Ok(result);
            })
           .WithTags(_strategyReview)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_strategyReview), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategyReviewPermission.View));

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
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_strategyReview), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategyReviewPermission.View));

            app.MapGet("/kpis/{kraRoadMapId:long}/{year:int}", async (long kraRoadMapId, int year,  IKraRoadMapKpiService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetKpiByRoadMapIdAsync(kraRoadMapId, year, cancellationToken);

                return Results.Ok(result);
            })  
            .WithTags(_strategyReview)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_strategyReview), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategyReviewPermission.View));
        }
    }
}
