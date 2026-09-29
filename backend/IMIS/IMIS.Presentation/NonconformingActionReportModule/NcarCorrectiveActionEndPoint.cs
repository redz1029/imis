using Carter;
using IMIS.Application.NonconformingActionReportModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using System.Threading;

namespace IMIS.Presentation.NonconformingActionReportModule
{
    public class NcarCorrectiveActionEndPoints : CarterModule
    {
        private const string _ncarCorrectiveActionTag = "NCAR Corrective Action";

        public NcarCorrectiveActionEndPoints() : base("/ncarcorrectiveaction")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async ([FromBody] NcarCorrectiveActionDto dto, INcarCorrectiveActionService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_ncarCorrectiveActionTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_ncarCorrectiveActionTag);

            // UPDATE
            app.MapPut("/", async ([FromBody] NcarCorrectiveActionDto dto, INcarCorrectiveActionService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_ncarCorrectiveActionTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_ncarCorrectiveActionTag);

            // GET BY ID
            app.MapGet("/{id:long}", async (long id, INcarCorrectiveActionService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_ncarCorrectiveActionTag);

            // GET PAGINATED
            app.MapGet("/page", async (int page, int pageSize, INcarCorrectiveActionService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_ncarCorrectiveActionTag);

            // SOFT DELETE
            app.MapDelete("/{id:long}", async (long id, INcarCorrectiveActionService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_ncarCorrectiveActionTag, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_ncarCorrectiveActionTag);
        }
    }
}
