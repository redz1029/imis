using Carter;
using IMIS.Application.ServiceHeadOfficesModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.ServiceHeadOfficesModule
{
    public class ServiceHeadOfficesEndPoints : CarterModule
    {
        private const string _serviceHeadOffices = "Service Head Offices";
        public ServiceHeadOfficesEndPoints() : base("/serviceHeadOffices")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] ServiceHeadOfficesDto serviceHeadOfficesDto, IServiceHeadOfficesService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(serviceHeadOfficesDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_serviceHeadOffices, cancellationToken);
                return Results.Ok(serviceHeadOfficesDto);
            })
            .WithTags(_serviceHeadOffices);

            app.MapGet("/", async (IServiceHeadOfficesService service, CancellationToken cancellationToken) =>
            {
                var serviceHeadOfficesDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(serviceHeadOfficesDto);
            })
            .WithTags(_serviceHeadOffices)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_serviceHeadOffices), true);

            app.MapGet("/{id}", async (int id, IServiceHeadOfficesService service, CancellationToken cancellationToken) =>
            {
                var serviceHeadOfficesDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return serviceHeadOfficesDto != null ? Results.Ok(serviceHeadOfficesDto) : Results.NotFound();
            })
            .WithTags(_serviceHeadOffices)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_serviceHeadOffices), true);

            app.MapPut("/{id}", async (int id, [FromBody] ServiceHeadOfficesDto serviceHeadOfficesDto, IServiceHeadOfficesService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {

                var existingUserOffice = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                await service.SaveOrUpdateAsync(serviceHeadOfficesDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_serviceHeadOffices, cancellationToken);
                return Results.Ok(serviceHeadOfficesDto);
            })
           .WithTags(_serviceHeadOffices);

            app.MapGet("/page", async (int page, int pageSize, IServiceHeadOfficesService service, CancellationToken cancellationToken) =>
            {
                var paginatedserviceHeadOfficesDto = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedserviceHeadOfficesDto;

            })
          .WithTags(_serviceHeadOffices)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_serviceHeadOffices), true);

            app.MapDelete("/{id:int}", async (int id, IServiceHeadOfficesService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_serviceHeadOffices, cancellationToken);

                return result ? Results.Ok(new { message = "Service Head Offices deleted successfully." })
                              : Results.NotFound(new { message = "Service Head Office Template not found." });
            })
           .WithTags(_serviceHeadOffices);
        }
    }
}
