using Carter;
using IMIS.Application.EvaluatorOfficesModule;
using IMIS.Application.IndividualStrategicAlignmentTreePeriodModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.ISATPeriodModule
{
    public class ISATPeriodEndPoint : CarterModule
    {
        private const string  _iSATPeriod = "ISAT Period";
        public ISATPeriodEndPoint() : base("/ISATPeriod")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] ISATPeriodDto iSATPeriodDto, IISATPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(iSATPeriodDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_iSATPeriod, cancellationToken);
                return Results.Ok(iSATPeriodDto);
            })
            .WithTags(_iSATPeriod);

            app.MapGet("/", async (IISATPeriodService service, CancellationToken cancellationToken) =>
            {
                var period = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(period);
            })
            .WithTags(_iSATPeriod)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_iSATPeriod), true);

            app.MapGet("/{id}", async (int id, IISATPeriodService service, CancellationToken cancellationToken) =>
            {
                var iSATPeriodDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return iSATPeriodDto != null ? Results.Ok(iSATPeriodDto) : Results.NotFound();
            })
            .WithTags(_iSATPeriod)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_iSATPeriod), true);

            app.MapPut("/{id}", async (int id, [FromBody] ISATPeriodDto iSATPeriodDto, IISATPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                try
                {
                    var existingPeriod = await service.GetByIdAsync(id, cancellationToken);
                    if (existingPeriod == null)
                        return Results.NotFound($"ISAT Period with ID {id} not found.");

                    iSATPeriodDto.Id = id;
                    await service.SaveOrUpdateAsync(iSATPeriodDto, cancellationToken).ConfigureAwait(false);
                    await cache.EvictByTagAsync(_iSATPeriod, cancellationToken);
                    return Results.Ok(iSATPeriodDto);


                }
                catch (InvalidOperationException ex) when (ex.InnerException is DbUpdateConcurrencyException)
                {
                    return Results.Conflict("The record was modified by another user. Please reload and try again.");
                }
            })
          .WithTags(_iSATPeriod);

            app.MapGet("/page", async (int page, int pageSize, IISATPeriodService service, CancellationToken cancellationToken) =>
            {
                var paginatedISATPeriod = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedISATPeriod);
            })
            .WithTags(_iSATPeriod)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_iSATPeriod), true);

            app.MapDelete("/{id:int}", async (int id, IISATPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_iSATPeriod, cancellationToken);

                return result ? Results.Ok(new { message = "Period deleted successfully." })
                              : Results.NotFound(new { message = "Period not found." });
            })
          .WithTags(_iSATPeriod);
        }
    }
}
