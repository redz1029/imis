using Carter;
using IMIS.Application.PgsPeriodModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsPeriodModuleAPI
{
    public class PgsPeriodEndPoints : CarterModule
    {
        private const string _pgsPeriodTag = "PGS Period";
        public PgsPeriodEndPoints() : base("/pgsPeriod")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {            
            app.MapPost("/", async ([FromBody] PgsPeriodDto pgsPeriodDto, IPgsPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {                
                var createdPgsPeriod = await service.SaveOrUpdateAsync(pgsPeriodDto, cancellationToken).ConfigureAwait(false);
                //Clear the cache for this data after updating
                await cache.EvictByTagAsync(_pgsPeriodTag, cancellationToken);
                return Results.Created($"/pgsPeriod/{createdPgsPeriod.Id}", createdPgsPeriod);
            })
            .WithTags(_pgsPeriodTag);

            app.MapGet("/", async (IPgsPeriodService service, CancellationToken cancellationToken) =>  
            {
                var period = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(period);
            })
            .WithTags(_pgsPeriodTag)   
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsPeriodTag), true);
        
            app.MapPut("/{id}", async (int id, [FromBody] PgsPeriodDto pgsPeriodDto, IPgsPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {                             
                var existingPeriod = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingPeriod == null)
                {
                    return Results.NotFound($"PGS Period with ID {id} not found.");
                }
               
                pgsPeriodDto.Id = id;
                var updatedPgsPeriod = await service.SaveOrUpdateAsync(pgsPeriodDto, cancellationToken).ConfigureAwait(false);
              
                await cache.EvictByTagAsync(_pgsPeriodTag, cancellationToken);
                return Results.Ok(updatedPgsPeriod);
            })
            .WithTags(_pgsPeriodTag);         
            app.MapGet("/page", async (int page, int pageSize, IPgsPeriodService service, CancellationToken cancellationToken) =>
            {
                var paginatedPgsPeriod = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedPgsPeriod);
            })
            .WithTags(_pgsPeriodTag);
                
        }
    }
}
