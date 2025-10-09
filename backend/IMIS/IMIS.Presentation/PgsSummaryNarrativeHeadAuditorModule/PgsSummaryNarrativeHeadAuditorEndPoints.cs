using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PgsSummaryNarrativeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsSummaryNarrativeHeadAuditorModule
{
    public class PgsSummaryNarrativeHeadAuditorEndPoints : CarterModule
    {
        private const string _pgsSummaryNarrativeTag = "PgsSummaryNarrativeAuditorHeadTag";
        public readonly PgsSummaryNarrativePermissions _pgsSummaryNarrativePermissions = new();
        public PgsSummaryNarrativeHeadAuditorEndPoints() : base("/pgsSummaryNarrativeAuditorHead")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PGSSummaryNarrativeDto narrativeDto, IPGSSummaryNarrativeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(narrativeDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsSummaryNarrativeTag, cancellationToken);
                return Results.Ok(narrativeDto);
            })
           .WithTags(_pgsSummaryNarrativeTag)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pgsSummaryNarrativePermissions.Add));

            app.MapGet("/{id}", async (int id, IPGSSummaryNarrativeService service, CancellationToken cancellationToken) =>
            {
                var office = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return office != null ? Results.Ok(office) : Results.NotFound();
            })
            .WithTags(_pgsSummaryNarrativeTag)         
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsSummaryNarrativeTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pgsSummaryNarrativePermissions.View)); ;

            app.MapGet("/byHeadAuditor", async (int? periodId, int? office, IPGSSummaryNarrativeService service, CancellationToken cancellationToken) =>
            {
                var narratives = await service.GetNarrativesForHeadAuditorAsync(periodId, office, cancellationToken);

                return Results.Ok(narratives);
            })
            .WithTags(_pgsSummaryNarrativeTag)          
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_pgsSummaryNarrativeTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pgsSummaryNarrativePermissions.View));                         
        }
    }
}
