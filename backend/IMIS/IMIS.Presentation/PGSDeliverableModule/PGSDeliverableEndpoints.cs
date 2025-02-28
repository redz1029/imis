using Carter;
using IMIS.Application.PgsModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
            app.MapPost("/", async ([FromBody] List<PGSDeliverableDto> pgsDtos, IPGSDeliverableService service, CancellationToken cancellationToken) =>
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
                    createdPgsList.Add(createdPgs);
                }

                // Log response
                Console.WriteLine($"Created PGS Count: {createdPgsList.Count}");
                Console.WriteLine("Created Deliverables:");
                Console.WriteLine(JsonSerializer.Serialize(createdPgsList, new JsonSerializerOptions { WriteIndented = true }));

                return Results.Created("/Deliverable", createdPgsList);
            })
            .WithTags(_pgsTag);
        }
    }
}
