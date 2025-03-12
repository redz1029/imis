using Carter;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Application.UserOfficeModule;
using IMIS.Domain;
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
           
            app.MapGet("/{id:long}", async (long id, IPgsReadinessRatingRepository repository, CancellationToken cancellationToken) =>
            {
                var pgsReadiness = await repository.GetByIdAsync(id, cancellationToken);
                return pgsReadiness != null ? Results.Ok(pgsReadiness) : 
                Results.NotFound("PGS Readiness record not found.");
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

            app.MapGet("/", async (IPgsReadinessRatingRepository service, CancellationToken cancellationToken) => 
            {
                var Kradto = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(Kradto);
            })
           .WithTags(_pgsTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);


            app.MapPut("/{id}", async (int id, [FromBody] PgsReadinessRatingDto pgsReadiness, IPgsReadinessRatingService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (pgsReadiness == null)
                {
                    return Results.BadRequest("Pgs Readiness data is required.");
                }
                var existingPgsReadiness = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingPgsReadiness == null)
                {
                    return Results.NotFound($"Pgs Readiness with ID {id} not found.");
                }

                var updatedUserOffice = await service.SaveOrUpdateAsync(pgsReadiness, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Ok(updatedUserOffice);
            })
         .WithTags(_pgsTag);
        }
    }
}
