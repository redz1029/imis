using Base.Auths.Permissions;
using Carter;
using IMIS.Application.BreakThroughScoringModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.BreakThroughScoringModule
{
    public class BreakThroughScoringEndPoint : CarterModule
    {
        private const string _breakThroughScoring = "Break Through Scoring";
        public readonly BreakThroughScoringPermission _breakThroughScoringPermission = new();

        public BreakThroughScoringEndPoint() : base("/BreakThroughScoring")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] BreakThroughScoringDto breakThroughScoringDto, IBreakThroughScoringService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(breakThroughScoringDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_breakThroughScoring, cancellationToken);
                return Results.Ok(breakThroughScoringDto);
            })
           .WithTags(_breakThroughScoring)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _breakThroughScoringPermission.Add));           

            app.MapGet("/{deliverableId:long}", async (long deliverableId, IBreakThroughScoringService service, CancellationToken cancellationToken) =>
           {
               var result = await service.GetByDeliverableIdAsync(deliverableId, cancellationToken);
               return Results.Ok(result);
           })
           .WithTags(_breakThroughScoring)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_breakThroughScoring), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _breakThroughScoringPermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] BreakThroughScoringDto breakThroughScoringDto, IBreakThroughScoringService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var breakThroughScoring = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (breakThroughScoring == null)
                {
                    return Results.NotFound($"Break Through Scoring with ID {id} not found.");
                }
                await service.SaveOrUpdateAsync(breakThroughScoringDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_breakThroughScoring, cancellationToken);
                return Results.Ok(breakThroughScoringDto);
            })
            .WithTags(_breakThroughScoring)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _breakThroughScoringPermission.Edit));     
        }
    }
}
