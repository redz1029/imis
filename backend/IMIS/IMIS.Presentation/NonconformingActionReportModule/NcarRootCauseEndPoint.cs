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
    public class NcarRootCauseEndPoints : CarterModule
    {
        private const string _ncarRootCauseTag = "NCAR Root Cause";

        public NcarRootCauseEndPoints() : base("/ncarrootcause")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async ([FromBody] NcarRootCauseDto dto, INcarRootCauseService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_ncarRootCauseTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_ncarRootCauseTag);

            // UPDATE
            app.MapPut("/", async ([FromBody] NcarRootCauseDto dto, INcarRootCauseService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_ncarRootCauseTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_ncarRootCauseTag);

            // GET BY ID
            app.MapGet("/{id:long}", async (long id, INcarRootCauseService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_ncarRootCauseTag);

            // GET PAGINATED
            app.MapGet("/page", async (int page, int pageSize, INcarRootCauseService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_ncarRootCauseTag);

            // SOFT DELETE
            app.MapDelete("/{id:long}", async (long id, INcarRootCauseService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_ncarRootCauseTag, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_ncarRootCauseTag);
        }
    }
}
