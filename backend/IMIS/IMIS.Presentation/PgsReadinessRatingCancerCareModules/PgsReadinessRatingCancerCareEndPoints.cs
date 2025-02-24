using Carter;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.PgsReadinessRatingCancerCareModules
{
    public class PgsReadinessRatingCancerCareEndPoints : CarterModule
    {
        private const string _pgsTag = "PGS Readiness Rating - Cancer Care";

        public PgsReadinessRatingCancerCareEndPoints() : base("/PgsReadiness") { }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // POST - Create or Update PGS Readiness Rating
            app.MapPost("/", async ([FromBody] PGSReadinessRatingCancerCareDto pgsReadinessDto, IPgsReadinessRatingCancerCareService service, CancellationToken cancellationToken) =>
            {
                if (pgsReadinessDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }
                var createdPgsReadiness = await service.SaveOrUpdateAsync(pgsReadinessDto, cancellationToken).ConfigureAwait(false);
                return Results.Created($"/PgsReadiness/{createdPgsReadiness.Id}", createdPgsReadiness);
            })
            .WithTags(_pgsTag);

            // GET - Retrieve a PGS Readiness Rating by ID
            app.MapGet("/{id:long}", async (long id, IPGSReadinessRatingCancerCareRepository repository, CancellationToken cancellationToken) =>
            {
                var pgsReadiness = await repository.GetByIdAsync(id, cancellationToken);
                return pgsReadiness != null ? Results.Ok(pgsReadiness) : Results.NotFound("PGS Readiness record not found.");
            })
            .WithTags(_pgsTag);
        }
    }
}
