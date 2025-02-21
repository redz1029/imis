using Carter;
using IMIS.Application.PgsModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.PGSModule
{
    public class PGSDeliverableEndpoints : CarterModule
    {
        private const string _pgsTag = "Create PGS Deliverable"; 
        public PGSDeliverableEndpoints() : base("/Deliverable")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // POST endpoint for creating a PGS record
            app.MapPost("/", async ([FromBody] PGSDeliverableDto pgsDto, IPGSDeliverableService service, CancellationToken cancellationToken) =>
            {
                if (pgsDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }
                var createdPgs = await service.SaveOrUpdateAsync(pgsDto, cancellationToken).ConfigureAwait(false);
                return Results.Created($"/Deliverable/{createdPgs.Id}", createdPgs); 
            })
            .WithTags(_pgsTag);                   
        }
    }
}
