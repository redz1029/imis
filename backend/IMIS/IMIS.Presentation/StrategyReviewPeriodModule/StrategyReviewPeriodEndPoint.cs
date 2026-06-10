using Carter;
using IMIS.Application.StrategyReviewPeriodModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.StrategyReviewPeriodModule
{
    public class StrategyReviewPeriodEndPoint : CarterModule
    {
        private const string _strategyReviewPeriodTag = "Strategy Review Period";
        public StrategyReviewPeriodEndPoint() : base("/strategyReviewPeriod")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] StrategyReviewPeriodDto strategyReviewPeriodDto, IStrategyReviewPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(strategyReviewPeriodDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_strategyReviewPeriodTag, cancellationToken);
                return Results.Ok(strategyReviewPeriodDto);
            })
          .WithTags(_strategyReviewPeriodTag);

            app.MapGet("/", async (IStrategyReviewPeriodService service, CancellationToken cancellationToken) =>
            {
                var strategyReviewPeriodDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(strategyReviewPeriodDto);
            })
          .WithTags(_strategyReviewPeriodTag)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_strategyReviewPeriodTag), true);

            app.MapGet("/{id}", async (int id, IStrategyReviewPeriodService service, CancellationToken cancellationToken) =>
            {
                var strategyReviewPeriodDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return strategyReviewPeriodDto != null ? Results.Ok(strategyReviewPeriodDto) : Results.NotFound();
            })
           .WithTags(_strategyReviewPeriodTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_strategyReviewPeriodTag), true);

            app.MapPut("/{id}", async (int id, [FromBody] StrategyReviewPeriodDto strategyReviewPeriodDto, IStrategyReviewPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                try
                {
                    var existingPeriod = await service.GetByIdAsync(id, cancellationToken);
                    strategyReviewPeriodDto.Id = id;
                    await service.SaveOrUpdateAsync(strategyReviewPeriodDto, cancellationToken).ConfigureAwait(false);
                    await cache.EvictByTagAsync(_strategyReviewPeriodTag, cancellationToken);
                    return Results.Ok(_strategyReviewPeriodTag);
                }
                catch (InvalidOperationException ex) when (ex.InnerException is DbUpdateConcurrencyException)
                {
                    return Results.Conflict("The record was modified by another user. Please reload and try again.");
                }
            })
           .WithTags(_strategyReviewPeriodTag);

            app.MapGet("/page", async (int page, int pageSize, IStrategyReviewPeriodService service, CancellationToken cancellationToken) =>
            {
                var paginatedReviewPeriod = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedReviewPeriod);
            })
          .WithTags(_strategyReviewPeriodTag)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_strategyReviewPeriodTag), true);

            app.MapDelete("/{id:int}", async (int id, IStrategyReviewPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_strategyReviewPeriodTag, cancellationToken);

                return result ? Results.Ok(new { message = "Review Period deleted successfully." })
                              : Results.NotFound(new { message = "Review Period not found." });
            })
           .WithTags(_strategyReviewPeriodTag);
        }
    }
}
