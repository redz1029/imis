using Carter;
using IMIS.Application.OfficeModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsReadinessRatingCancerCareModules
{
    public class PgsReadinessRatingEndPoints : CarterModule
    {
        private const string _pgsTag = "PGS Readiness Rating";

        public PgsReadinessRatingEndPoints() : base("/PgsReadiness") { }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            
            app.MapPost("/", async ([FromBody] PgsReadinessRatingDto pgsReadinessDto, IPgsReadinessRatingService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (pgsReadinessDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                } 
                var createdPgsReadiness = await service.SaveOrUpdateAsync(pgsReadinessDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Created($"/PgsReadiness/{createdPgsReadiness.Id}", createdPgsReadiness);
            })
            .WithTags(_pgsTag);

            // GET - Retrieve a PGS Readiness Rating by ID
            app.MapGet("/{id:long}", async (long id, IPgsReadinessRatingRepository repository, CancellationToken cancellationToken) =>
            {
                var pgsReadiness = await repository.GetByIdAsync(id, cancellationToken);
                return pgsReadiness != null ? Results.Ok(pgsReadiness) : 
                Results.NotFound("PGS Readiness record not found.");
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
        }
    }
}
