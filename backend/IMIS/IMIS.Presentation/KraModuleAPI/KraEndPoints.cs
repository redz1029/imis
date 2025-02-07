using Carter;
using IMIS.Application.PgsKraModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.KraModuleAPI
{   
    public class KraEndPoints : CarterModule
    {
        private const string _pgsTag = "Create KRA";

        public KraEndPoints() : base("/Kra")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
           
            app.MapPost("/", async ([FromBody] KraDto KraDto, IKraService service, CancellationToken cancellationToken) =>
            {
                if (KraDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }

                var createdKra = await service.SaveOrUpdateAsync(KraDto, cancellationToken).ConfigureAwait(false);
                return Results.Created($"/Kra/{createdKra.Id}", createdKra);
            })
            .WithTags(_pgsTag);

        }
      
    }
}
