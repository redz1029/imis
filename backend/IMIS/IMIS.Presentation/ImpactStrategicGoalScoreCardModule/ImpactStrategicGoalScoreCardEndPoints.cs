using Base.Auths.Permissions;
using Carter;
using IMIS.Application.ImpactStrategicGoalScoreCardModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.ImpactStrategicGoalScoreCardModule
{
    public class ImpactStrategicGoalScoreCardEndPoints : CarterModule
    {
        private const string _impactStrategicGoalScoreCard = "Impact Strategic Goal ScoreCard";
        public readonly ImpactStrategicGoalScoreCardPermission _impactStrategicGoalScoreCardPermission = new();
        public ImpactStrategicGoalScoreCardEndPoints() : base("/ImpactStrategicGoalScoreCard")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] ImpactStrategicGoalScoreCardDto dto, IImpactStrategicGoalScoreCardService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_impactStrategicGoalScoreCard, cancellationToken);
                return Results.Ok(dto);
            })
           .WithTags(_impactStrategicGoalScoreCard)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _impactStrategicGoalScoreCardPermission.Add));

            app.MapGet("/{id}", async (int id, IImpactStrategicGoalScoreCardService service, CancellationToken cancellationToken) =>
            {
                var dto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return dto != null ? Results.Ok(dto) : Results.NotFound();
            })
            .WithTags(_impactStrategicGoalScoreCard)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_impactStrategicGoalScoreCard), true);

            app.MapPut("/{id}", async (int id, [FromBody] ImpactStrategicGoalScoreCardDto impactStrategicGoalScoreCardDto, IImpactStrategicGoalScoreCardService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existingkraRoadMapDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                await service.SaveOrUpdateAsync(impactStrategicGoalScoreCardDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_impactStrategicGoalScoreCard, cancellationToken);
                return Results.Ok(impactStrategicGoalScoreCardDto);
            })
            .WithTags(_impactStrategicGoalScoreCard)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _impactStrategicGoalScoreCardPermission.Edit));


            app.MapGet("/page/pgsPeriod/{id}", async (long? pgsPeriodId, int page, int pageSize, IImpactStrategicGoalScoreCardService service, CancellationToken cancellationToken) =>
            {
                var paginatedimpactStrategicGoalScoreCardDto = await service.GetPaginatedAsync(pgsPeriodId, page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedimpactStrategicGoalScoreCardDto);
            })
            .WithTags(_impactStrategicGoalScoreCard)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_impactStrategicGoalScoreCard), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _impactStrategicGoalScoreCardPermission.View));

            app.MapDelete("/{id:int}", async (int id, IImpactStrategicGoalScoreCardService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_impactStrategicGoalScoreCard, cancellationToken);

                return result ? Results.Ok(new { message = "Deleted successfully." })
                              : Results.NotFound(new { message = "RoadMap not found." });
            })
          .WithTags(_impactStrategicGoalScoreCard)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _impactStrategicGoalScoreCardPermission.Edit));
        }
    }
}
