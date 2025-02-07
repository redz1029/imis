using Carter;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.PgsPeriodModuleAPI
{


    public class PgsPeriodEndPoints : CarterModule
    {
        private const string _pgsTag = "Create PGS Period";

        public PgsPeriodEndPoints() : base("/PgsPeriod")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // POST endpoint for creating a PGS record
            app.MapPost("/", async ([FromBody] PgsPeriodDto PgsPeriodDto, IPgsPeriodService service, CancellationToken cancellationToken) =>
            {
                if (PgsPeriodDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }

                var createdPgsPeriod = await service.SaveOrUpdateAsync(PgsPeriodDto, cancellationToken).ConfigureAwait(false);
                return Results.Created($"/PgsPeriod/{createdPgsPeriod.Id}", createdPgsPeriod);
            })
            .WithTags(_pgsTag);

        }

    }
}
