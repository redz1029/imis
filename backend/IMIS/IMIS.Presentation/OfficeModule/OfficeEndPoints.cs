using Carter;
using IMIS.Application.OfficeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.OfficeModule
{
    public class OfficeEndPoints : CarterModule
    {

        private const string _OfficeTag = "Office";
        public OfficeEndPoints() : base("/Office")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {            
            app.MapPost("/", async ([FromBody] OfficeDto office, IOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (office == null)
                {
                    return Results.BadRequest("Invalid office data.");
                }                
                await service.SaveOrUpdateAsync(office, cancellationToken).ConfigureAwait(false);                
                await cache.EvictByTagAsync(_OfficeTag, cancellationToken);
                return Results.Ok(office);               
            })
            .WithTags(_OfficeTag);
             
            app.MapGet("/", async (IOfficeService service, CancellationToken cancellationToken) =>
            {
                var offices = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(offices);
            })
            .WithTags(_OfficeTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_OfficeTag), true);

            app.MapGet("/filter/{name}", async (string name, IOfficeService service, CancellationToken cancellationToken) =>
            {
                int noOfResults = 10;
                var offices = await service.FilterByName(name, noOfResults, cancellationToken).ConfigureAwait(false);
                return offices != null ? Results.Ok(offices) : Results.NoContent();
            })
           .WithTags(_OfficeTag)          
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_OfficeTag), true);

            app.MapGet("/{id}", async (int id, IOfficeService service, CancellationToken cancellationToken) =>
            {
                var Office = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return Office != null ? Results.Ok(Office) : Results.NotFound();
            })
            .WithTags(_OfficeTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_OfficeTag), true);
        }
    }
}

