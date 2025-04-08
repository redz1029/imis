using Carter;
using IMIS.Application.OfficeModule;
using IMIS.Infrastructure.Auths;
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
        private const string _officeTag = "Office";
        public OfficeEndPoints() : base("/office")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {            
            app.MapPost("/", async ([FromBody] OfficeDto officeDto, IOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {                                
                await service.SaveOrUpdateAsync(officeDto, cancellationToken).ConfigureAwait(false);                
                await cache.EvictByTagAsync(_officeTag, cancellationToken);
                return Results.Ok(officeDto);               
            })
            .WithTags(_officeTag);

            app.MapGet("/", async (IOfficeService service, CancellationToken cancellationToken) =>
            {
                var offices = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(offices);
            })
            .WithTags(_officeTag)           
            .RequireAuthorization(a => a.RequireRole(RoleTypes.Administrator))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_officeTag), true);

            app.MapGet("/filter/{name}", async (string name, IOfficeService service, CancellationToken cancellationToken) =>
            {
                int officeNoOfResults = 10;
                var offices = await service.FilterByName(name, officeNoOfResults, cancellationToken).ConfigureAwait(false);
                return offices != null ? Results.Ok(offices) : Results.NoContent();
            })
            .WithTags(_officeTag)          
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_officeTag), true);
            app.MapGet("/{id}", async (int id, IOfficeService service, CancellationToken cancellationToken) =>
            {
                var office = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return office != null ? Results.Ok(office) : Results.NotFound();
            })
            .WithTags(_officeTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_officeTag), true);

            app.MapPut("/{id}", async (int id, [FromBody] OfficeDto office, IOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {               
                var existingOffice = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingOffice == null)
                {
                    return Results.NotFound($"Office with ID {id} not found.");
                }

                await service.SaveOrUpdateAsync(office, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_officeTag, cancellationToken);
                return Results.Ok(office);
            })
            .WithTags(_officeTag);
            app.MapGet("/page", async (int page, int pageSize, IOfficeService service, CancellationToken cancellationToken) =>
            {
                var paginatedOffice = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedOffice;
            })
            .WithTags(_officeTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_officeTag), true);
        }
    }
}

