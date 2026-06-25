using Carter;
using IMIS.Application.PerformanceValidationToolModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsSignatoryModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PerformanceValidationToolModule
{
    public class PerformanceValidationToolEndPoint : CarterModule
    {
        private const string _performanceValidationTool = "Performance Validation Tool";
        public PerformanceValidationToolEndPoint() : base("/performanceValidationTool")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PerformanceValidationToolDto dto, IPerformanceValidationToolService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_performanceValidationTool,  cancellationToken);
                return Results.Ok(dto);
            })
           .WithTags(_performanceValidationTool);

            app.MapGet("/{id:long}", async (long id, IPerformanceValidationToolService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);
                return result is null ? Results.NotFound() : Results.Ok(result);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true);

            app.MapGet("/", async (IPerformanceValidationToolService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_performanceValidationTool);

            app.MapPut("/", async ([FromBody] PerformanceValidationToolDto dto, IPerformanceValidationToolService service, IOutputCacheStore cache,  CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_performanceValidationTool, cancellationToken);  
                return Results.Ok(dto);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true);

            app.MapGet("/pgsAuditor/{roleId}", async (string roleId, long? officeId, long? pgsPeriodId, int page, int pageSize, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAuditorPgsDeliverableAsync(roleId, officeId, pgsPeriodId, page, pageSize, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true);

            app.MapGet("/pgsidlist", async (long? performanceGovernanceSystemId, IPerformanceValidationToolService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllPgsIdTool(performanceGovernanceSystemId, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool));

            app.MapGet("/pgsiddiverable/{id}", async (int id, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var performanceGovernanceSystem = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return performanceGovernanceSystem != null ? Results.Ok(performanceGovernanceSystem) : Results.NotFound();
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true);
           

            app.MapGet("/PgsSignatory", async (long? pgsSignatoryId, IPgsSignatoryService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllPgsSignatoryId(pgsSignatoryId, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool));

            app.MapPut("/submit", async ([FromBody] PerformanceValidationToolDto dto, string userId, IPerformanceValidationToolService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var submitted = await service.Submit(dto, userId, cancellationToken);

                await cache.EvictByTagAsync(_performanceValidationTool, cancellationToken);

                return Results.Created($"/performanceValidationTool/{submitted.Id}", submitted);
            })
           .WithTags(_performanceValidationTool);

            app.MapGet("/submit/userId/{userId}", async (string userId, long performanceValidationToolId, IPerformanceValidationToolService service, CancellationToken cancellationToken) =>
            {
                var dto = await service.GetByUserIdAndPerformanceValidationToolIdAsync(userId, performanceValidationToolId, cancellationToken);

                return dto != null ? Results.Ok(dto): Results.NotFound();
            })
            .WithTags(_performanceValidationTool)    
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true);
        }
    }
}
