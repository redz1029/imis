using Carter;
using IMIS.Application.PgsModule;
using IMIS.Application.UserOfficeModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using System.Text.Json;

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
            app.MapPost("/", async ([FromBody] List<PGSDeliverableDto> pgsDtos, IPGSDeliverableService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (pgsDtos == null || !pgsDtos.Any())
                {
                    return Results.BadRequest("PGS data list is required.");
                }

                var createdPgsList = new List<PGSDeliverableDto>();

                foreach (var pgsDto in pgsDtos)
                {
                    if (pgsDto.Id == 0) // Ensure ID is not explicitly set for new records
                    {
                        pgsDto.Id = 0;
                    }

                    var createdPgs = await service.SaveOrUpdateAsync(pgsDto, cancellationToken).ConfigureAwait(false);
                    await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                    createdPgsList.Add(createdPgs);
                }
                // Log response
                Console.WriteLine($"Created PGS Count: {createdPgsList.Count}");
                Console.WriteLine("Created Deliverables:");
                Console.WriteLine(JsonSerializer.Serialize(createdPgsList, new JsonSerializerOptions { WriteIndented = true }));
                return Results.Created("/Deliverable", createdPgsList);
            })
            .WithTags(_pgsTag);

            app.MapGet("/", async (IPGSDeliverableService service, CancellationToken cancellationToken) => // Get allAsync Data in the KRA Database
            {
                var Kradto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(Kradto);
            })
            .WithTags(_pgsTag);

            app.MapPut("/{id}", async (int id, [FromBody] PGSDeliverableDto pgsdeliverables, IPGSDeliverableService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (pgsdeliverables == null)
                {
                    return Results.BadRequest("Pgs Deliverable data is required.");
                }
                var existingPgsDeliverables = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingPgsDeliverables == null)
                {
                    return Results.NotFound($"User Office with ID {id} not found.");
                }

                var updatedPgsDeliverables = await service.SaveOrUpdateAsync(pgsdeliverables, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Ok(updatedPgsDeliverables);
            })
         .WithTags(_pgsTag);
        }
    }
}
