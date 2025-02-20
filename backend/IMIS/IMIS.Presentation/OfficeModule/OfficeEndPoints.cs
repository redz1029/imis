using Carter;
using IMIS.Application.OfficeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.OfficeModule
{
    public class OfficeEndPoints : CarterModule
    {

        private const string _auditorTag = "Office";
        public OfficeEndPoints() : base("/Office")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] OfficeDto Office, IOfficeService service, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(Office, cancellationToken).ConfigureAwait(false);
                return Results.Ok(Office);
            })
            .WithTags(_auditorTag);
            app.MapGet("/", async (IOfficeService service, CancellationToken cancellationToken) =>
            {
                var auditors = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(auditors);
            })
            .WithTags(_auditorTag);
            app.MapGet("/{id}", async (int id, IOfficeService service, CancellationToken cancellationToken) =>
            {
                var Office = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return Office != null ? Results.Ok(Office) : Results.NotFound();
            })
            .WithTags(_auditorTag);
        }
    }
}

