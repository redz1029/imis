using Carter;
using IMIS.Application.PgsModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;


namespace IMIS.Presentation.PGSModule
{
    public class PGSEndpoints : CarterModule
    {
        private const string _pgsTag = "Create PGS"; 

        public PGSEndpoints() : base("/pgs")
        {

        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // POST endpoint for creating a PGS record
            app.MapPost("/", async ([FromBody] PgsDto pgsDto, IPGSService service, CancellationToken cancellationToken) =>
            {
                if (pgsDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }

                var createdPgs = await service.CreateAsync(pgsDto, cancellationToken).ConfigureAwait(false);
                return Results.Created($"/pgs/{createdPgs.Id}", createdPgs); 
            })
            .WithTags(_pgsTag);

            // GET endpoint for fetching all PGS records
            app.MapGet("/", async (IPGSService service, CancellationToken cancellationToken) =>
            {
                var pgsList = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                if (pgsList == null || pgsList.Count == 0)
                {
                    return Results.NoContent(); 
                }
                return Results.Ok(pgsList); 
            })
            .WithTags(_pgsTag);

            // GET endpoint for fetching all active PGS records
            app.MapGet("/active", async (IPGSService service, CancellationToken cancellationToken) =>
            {
                var activePgsList = await service.GetAllActiveAsync(cancellationToken).ConfigureAwait(false);
                if (activePgsList == null || activePgsList.Count == 0)
                {
                    return Results.NoContent(); 
                }
                return Results.Ok(activePgsList);
            })
            .WithTags(_pgsTag);

           
        }
    }
}
