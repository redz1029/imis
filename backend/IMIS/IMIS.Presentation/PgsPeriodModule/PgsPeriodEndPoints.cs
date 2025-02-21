using Carter;
using IMIS.Application.PgsKraModule;
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

            app.MapGet("/", async (IPgsPeriodService service, CancellationToken cancellationToken) => // Get allAsync Data in the KRA Database
            {
                var Period = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(Period);
            })
            .WithTags(_pgsTag);          
            // PUT endpoint for updating an existing PGS period
            app.MapPut("/{id}", async (int id, [FromBody] PgsPeriodDto PgsPeriodDto, IPgsPeriodService service, CancellationToken cancellationToken) =>
            {
                if (PgsPeriodDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }
                // First, check if the period exists
                var existingPeriod = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingPeriod == null)
                {
                    return Results.NotFound($"PGS Period with ID {id} not found.");
                }
                // Update the existing period with new data
                PgsPeriodDto.Id = id;
                var updatedPgsPeriod = await service.SaveOrUpdateAsync(PgsPeriodDto, cancellationToken).ConfigureAwait(false);
                return Results.Ok(updatedPgsPeriod); // Return the updated period
            })
            .WithTags(_pgsTag);

        }
    }
}
