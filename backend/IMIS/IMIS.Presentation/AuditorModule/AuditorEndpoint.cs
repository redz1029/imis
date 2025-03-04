using Carter;
using IMIS.Application.AuditorModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditorModule
{
    public class AuditorEndpoint : CarterModule
    {
        private const string _auditorTag = "Auditor";
        public AuditorEndpoint() : base("/auditors")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] AuditorDto auditor, IAuditorService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(auditor, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditorTag, cancellationToken);
                return Results.Ok(auditor);
            })
            .WithTags(_auditorTag);

            app.MapGet("/", async (IAuditorService service, CancellationToken cancellationToken) =>
            {
                var auditors = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(auditors);
            })
            .WithTags(_auditorTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditorTag), true);

            app.MapGet("/filter/{name}", async (string name, IAuditorService service, CancellationToken cancellationToken) =>
            {
                int noOfResults = 10;
                var auditors = await service.FilteByName(name, noOfResults, cancellationToken).ConfigureAwait(false);
                return auditors != null ? Results.Ok(auditors) : Results.NoContent();
            })
            .WithTags(_auditorTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditorTag), true);

            app.MapGet("/{id}", async (int id, IAuditorService service, CancellationToken cancellationToken) =>
            {
                var auditor = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return auditor != null ? Results.Ok(auditor) : Results.NotFound();
            })
            .WithTags(_auditorTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditorTag), true);

        }
    }
}
