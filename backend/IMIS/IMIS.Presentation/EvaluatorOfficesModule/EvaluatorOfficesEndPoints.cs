using Carter;
using IMIS.Application.EvaluatorOfficesModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.EvaluatorOfficesModule
{
    public class EvaluatorOfficesEndPoints : CarterModule
    {
        private const string _evaluatorOffices = "Evaluator Offices";
        public EvaluatorOfficesEndPoints() : base("/evaluatorOffices")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] EvaluatorOfficesDto evaluatorOfficesDto, IEvaluatorOfficesService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(evaluatorOfficesDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_evaluatorOffices, cancellationToken);
                return Results.Ok(evaluatorOfficesDto);
            })
          .WithTags(_evaluatorOffices);

            app.MapGet("/", async (IEvaluatorOfficesService service, CancellationToken cancellationToken) =>
            {
                var evaluatorOfficesDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(evaluatorOfficesDto);
            })
            .WithTags(_evaluatorOffices)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_evaluatorOffices), true);

            app.MapGet("/{id}", async (int id, IEvaluatorOfficesService service, CancellationToken cancellationToken) =>
            {
                var evaluatorOfficesDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return evaluatorOfficesDto != null ? Results.Ok(evaluatorOfficesDto) : Results.NotFound();
            })
           .WithTags(_evaluatorOffices)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_evaluatorOffices), true);

            app.MapPut("/{id}", async (int id, [FromBody] EvaluatorOfficesDto evaluatorOfficesDto, IEvaluatorOfficesService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {

                var existingUserOffice = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);

                await service.SaveOrUpdateAsync(evaluatorOfficesDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_evaluatorOffices, cancellationToken);
                return Results.Ok(evaluatorOfficesDto);
            })
            .WithTags(_evaluatorOffices);

            app.MapGet("/page", async (int page, int pageSize, IEvaluatorOfficesService service, CancellationToken cancellationToken) =>
            {
                var paginatedevaluatorOfficesDto = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedevaluatorOfficesDto;

            })
            .WithTags(_evaluatorOffices)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_evaluatorOffices), true);

            app.MapDelete("/{id:int}", async (int id, IEvaluatorOfficesService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_evaluatorOffices, cancellationToken);

                return result ? Results.Ok(new { message = "Evaluator Offices deleted successfully." })
                              : Results.NotFound(new { message = "Evaluator Office Template not found." });
            })
            .WithTags(_evaluatorOffices);
        }
    }
}
