using Carter;
using IMIS.Application.PgsModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.PgsModuleAPI
{
   
    public class PgsAuditDetailsEndPoints : CarterModule
    {
        private const string _pgsTag = "Create PgsProjectAudit";

        public PgsAuditDetailsEndPoints() : base("/PgsAudit")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            
            app.MapPost("/", async ([FromBody] PgsAuditDetailsDto PgsDto, IPgsAuditDetailsService service, CancellationToken cancellationToken) =>
            {
                if (PgsDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }

                var createdPgs = await service.SaveOrUpdateAsync(PgsDto, cancellationToken).ConfigureAwait(false);
                return Results.Created($"/PgsAudit/{createdPgs.Id}", createdPgs);
            })
            .WithTags(_pgsTag);

        }

    }
}
