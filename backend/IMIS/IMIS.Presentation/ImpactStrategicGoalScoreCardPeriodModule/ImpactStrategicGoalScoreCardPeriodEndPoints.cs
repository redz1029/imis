using Base.Auths.Permissions;
using Carter;
using IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.ImpactStrategicGoalScoreCardPeriodModule
{
    public class ImpactStrategicGoalScoreCardPeriodEndPoints : CarterModule
    {
        private const string _impactStrategicGoalScoreCardPeriod = "Impact Strategic Goal ScoreCard Period";
        public readonly ImpactStrategicGoalScoreCardPeriodPermission _impactStrategicGoalScoreCardPeriodPermission = new();
        public ImpactStrategicGoalScoreCardPeriodEndPoints() : base("/impactStrategicGoalScoreCardPeriod")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] ImpactStrategicGoalScoreCardPeriodDto impactStrategicGoalScoreCardPeriodDto, IImpactStrategicGoalScoreCardPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(impactStrategicGoalScoreCardPeriodDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_impactStrategicGoalScoreCardPeriod, cancellationToken);
                return Results.Ok(impactStrategicGoalScoreCardPeriodDto);
            })
            .WithTags(_impactStrategicGoalScoreCardPeriod)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _impactStrategicGoalScoreCardPeriodPermission.Add));

            app.MapGet("/", async (IImpactStrategicGoalScoreCardPeriodService service, CancellationToken cancellationToken) =>
            {
                var period = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(period);
            })
            .WithTags(_impactStrategicGoalScoreCardPeriod)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_impactStrategicGoalScoreCardPeriod), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _impactStrategicGoalScoreCardPeriodPermission.View));


            app.MapGet("/{id}", async (int id, IImpactStrategicGoalScoreCardPeriodService service, CancellationToken cancellationToken) =>
            {
                var impactStrategicGoalScoreCardPeriodDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return impactStrategicGoalScoreCardPeriodDto != null ? Results.Ok(impactStrategicGoalScoreCardPeriodDto) : Results.NotFound();
            })
            .WithTags(_impactStrategicGoalScoreCardPeriod)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_impactStrategicGoalScoreCardPeriod), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _impactStrategicGoalScoreCardPeriodPermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] ImpactStrategicGoalScoreCardPeriodDto impactStrategicGoalScoreCardPeriodDto, IImpactStrategicGoalScoreCardPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {

                var existingimpactStrategicGoalScoreCardPeriod = await service.GetByIdAsync(id, cancellationToken);
                if (existingimpactStrategicGoalScoreCardPeriod == null)
                    return Results.NotFound($"Kra RoadMap Period with ID {id} not found.");

                impactStrategicGoalScoreCardPeriodDto.Id = id;
                await service.SaveOrUpdateAsync(impactStrategicGoalScoreCardPeriodDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_impactStrategicGoalScoreCardPeriod, cancellationToken);
                return Results.Ok(impactStrategicGoalScoreCardPeriodDto);

            })
            .WithTags(_impactStrategicGoalScoreCardPeriod)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _impactStrategicGoalScoreCardPeriodPermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IImpactStrategicGoalScoreCardPeriodService service, CancellationToken cancellationToken) =>
            {
                var paginatedimpactStrategicGoalScoreCardPeriodDto = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedimpactStrategicGoalScoreCardPeriodDto);
            })
            .WithTags(_impactStrategicGoalScoreCardPeriod)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_impactStrategicGoalScoreCardPeriod), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _impactStrategicGoalScoreCardPeriodPermission.View));

            app.MapDelete("/{id:int}", async (int id, IImpactStrategicGoalScoreCardPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_impactStrategicGoalScoreCardPeriod, cancellationToken);

                return result ? Results.Ok(new { message = " Period deleted successfully." })
                              : Results.NotFound(new { message = " Period not found." });
            })
            .WithTags(_impactStrategicGoalScoreCardPeriod)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _impactStrategicGoalScoreCardPeriodPermission.Edit));
        }
    }
}
