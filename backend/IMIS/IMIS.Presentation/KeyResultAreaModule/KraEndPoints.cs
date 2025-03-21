using Carter;
using IMIS.Application.PgsKraModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.KraModuleAPI
{
    public class KraEndPoints : CarterModule
    {
        private const string _pgsTag = "Create KRA";
        public KraEndPoints() : base("/Kra")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] KeyResultAreaDto KraDto, IKeyResultAreaService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (KraDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }
                var createdKra = await service.SaveOrUpdateAsync(KraDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Created($"/Kra/{createdKra.Id}", createdKra);
            })
            .WithTags(_pgsTag);
            app.MapGet("/", async (IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                var Kradto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(Kradto);
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
            app.MapGet("/filter/{name}", async (string name, IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                int noOfResults = 10;
                var kra = await service.FilterByName(name, noOfResults, cancellationToken).ConfigureAwait(false);
                return kra != null ? Results.Ok(kra) : Results.NoContent();
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
            app.MapGet("/{id}", async (int id, IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                var Kradto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return Kradto != null ? Results.Ok(Kradto) : Results.NotFound();
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
            app.MapPut("/{id}", async (int id, [FromBody] KeyResultAreaDto KraDto, IKeyResultAreaService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (KraDto == null)
                {
                    return Results.BadRequest("Kra data is required.");
                }
                var existingKra = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingKra == null)
                {
                    return Results.NotFound($"KRA with ID {id} not found.");
                }
                
                var updatedKra = await service.SaveOrUpdateAsync(KraDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Ok(updatedKra);
            })
            .WithTags(_pgsTag);
            app.MapGet("/page", async (int page, int pageSize, IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                var paginatedKras = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedKras);
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
        }
    }
}





