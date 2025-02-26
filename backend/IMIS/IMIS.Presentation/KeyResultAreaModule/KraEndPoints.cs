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
            app.MapPost("/", async ([FromBody] KeyResultAreaDto KraDto, IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                if (KraDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }
                var createdKra = await service.SaveOrUpdateAsync(KraDto, cancellationToken).ConfigureAwait(false);
                return Results.Created($"/Kra/{createdKra.Id}", createdKra);
            })
            .WithTags(_pgsTag);
            app.MapGet("/", async (IKeyResultAreaService service, CancellationToken cancellationToken) => // Get allAsync Data in the KRA Database
            {
                var Kradto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(Kradto);
            })

           .WithTags(_pgsTag);
            app.MapGet("/{id}", async (int id, IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                var Kradto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return Kradto != null ? Results.Ok(Kradto) : Results.NotFound();
            })
            .WithTags(_pgsTag);
            app.MapPut("/{id}", async (int id, [FromBody] KeyResultAreaDto KraDto, IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                if (KraDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }
                var existingKra = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingKra == null)
                {
                    return Results.NotFound($"KRA with ID {id} not found.");
                }
                // Call to update the data (like setting 'isDeleted' to true) -- No function yet
                var updatedKra = await service.SaveOrUpdateAsync(KraDto, cancellationToken).ConfigureAwait(false);

                return Results.Ok(updatedKra); // Return the updated KRA
            })
            .WithTags(_pgsTag);
        }
    }
}





