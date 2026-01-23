using Carter;
using IMIS.Application.StandardVersionModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.StandardVersionModule
{
    public class StandardVersionEndpoint : CarterModule
    {
        private const string _tag = "StandardVersion";

        public StandardVersionEndpoint() : base("/api/StandardVersion")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] StandardVersionDto dto, IStandardVersionService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);

            app.MapGet("/", async (IStandardVersionService service, CancellationToken cancellationToken) =>
            {
                var versions = await service.GetAllAsync(cancellationToken);
                return versions != null ? Results.Ok(versions) : Results.NoContent();
            })
            .WithTags(_tag);

            app.MapGet("/{id}", async (int id, IStandardVersionService service, CancellationToken cancellationToken) =>
            {
                var version = await service.GetByIdAsync(id, cancellationToken);
                return version != null ? Results.Ok(version) : Results.NotFound();
            })
            .WithTags(_tag);

            app.MapGet("/{id}/with-standards", async (int id, IStandardVersionService service, CancellationToken cancellationToken) =>
            {
                var version = await service.GetByIdWithIsoStandardsAsync(id, cancellationToken);
                return version != null ? Results.Ok(version) : Results.NotFound();
            })
            .WithTags(_tag);

            app.MapGet("/filter/{name}", async (string name, IStandardVersionService service, CancellationToken cancellationToken) =>
            {
                const int noOfResults = 10;
                var versions = await service.FilterByName(name, noOfResults, cancellationToken);
                return versions != null ? Results.Ok(versions) : Results.NoContent();
            })
            .WithTags(_tag);

            app.MapGet("/paginate/{page}/{pageSize}", async (int page, int pageSize, IStandardVersionService service, CancellationToken cancellationToken) =>
            {
                var paginatedVersions = await service.GetPaginatedAsync(page, pageSize, cancellationToken);
                return Results.Ok(paginatedVersions);
            })
            .WithTags(_tag);

            app.MapPut("/{id}", async (int id, [FromBody] StandardVersionDto dto, IStandardVersionService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existing = await service.GetByIdAsync(id, cancellationToken);
                if (existing == null)
                    return Results.NotFound($"StandardVersion with ID {id} not found.");
                dto.Id = id;
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);

            app.MapDelete("/{id}", async (int id, IStandardVersionService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);
                if (result)
                {
                    await cache.EvictByTagAsync(_tag, cancellationToken);
                    return Results.Ok(new { message = "StandardVersion deleted successfully." });
                }
                return Results.NotFound(new { message = "StandardVersion not found." });
            })

            .WithTags(_tag);
        }
    }
}
