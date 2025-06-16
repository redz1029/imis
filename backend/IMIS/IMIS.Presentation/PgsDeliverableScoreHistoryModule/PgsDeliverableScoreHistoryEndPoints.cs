﻿
using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PgsDeliverableScoreHistoryModule;
using IMIS.Application.PgsPeriodModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsDeliverableScoreHistoryModule
{
    public class PgsDeliverableScoreHistoryEndPoints : CarterModule
    {
        private const string _pgsDeliverableScoreHistory = "PgsDeliverable Score History";
        public readonly PgsDeliverableScoreHistoryPermission _pgsDeliverableScoreHistoryPermission = new();

        public PgsDeliverableScoreHistoryEndPoints() : base("/pgsDeliverableScoreHistory")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PgsDeliverableScoreHistoryDto pgsDeliverableScoreHistoryDto, IPgsDeliverableScoreHistoryService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var createdTeam = await service.SaveOrUpdateAsync(pgsDeliverableScoreHistoryDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsDeliverableScoreHistory, cancellationToken);
                return Results.Created($"/pgsDeliverableScoreHistory/{createdTeam}", createdTeam);
            })
           .WithTags(_pgsDeliverableScoreHistory)
           .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim, _pgsDeliverableScoreHistoryPermission.Score));

            app.MapGet("/", async (IPgsDeliverableScoreHistoryService service, CancellationToken cancellationToken) =>
            {
                var period = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(period);
            })
            .WithTags(_pgsDeliverableScoreHistory)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsDeliverableScoreHistory), true)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _pgsDeliverableScoreHistoryPermission.View));
        }
    }
}
