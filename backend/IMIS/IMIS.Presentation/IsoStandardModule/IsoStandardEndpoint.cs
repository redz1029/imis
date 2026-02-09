using Base.Auths.Permissions;
using Carter;
using IMIS.Application.IsoStandardModule;
using IMIS.Application.PgsModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using System.Text.Json;

namespace IMIS.Presentation.IsoStandardModule
{
    public class IsoStandardEndpoint : CarterModule
    {
        private const string _tag = "IsoStandard";

        public IsoStandardEndpoint() : base("IsoStandard")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {


            app.MapPost("/", async ([FromBody] List<IsoStandardDto> isoDtos,IIsoStandardService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (isoDtos == null || !isoDtos.Any())
                {
                    return Results.BadRequest("ISO data list is required.");
                }

                var createdIsoList = new List<IsoStandardDto>();
                foreach (var isoDto in isoDtos)
                {
                    await service.SaveOrUpdateAsync(isoDto, cancellationToken);
                }

                await cache.EvictByTagAsync(_tag, cancellationToken);

                return Results.Ok();
            })      
            .WithTags(_tag);



            app.MapGet("/", async (IIsoStandardService service, CancellationToken cancellationToken) =>
            {
                var standards = await service.GetAllAsync(cancellationToken);
                return standards != null ? Results.Ok(standards) : Results.NoContent();
            })
            .WithTags(_tag);

            app.MapGet("/{id}", async (long id, IIsoStandardService service, CancellationToken cancellationToken) =>
            {
                var standard = await service.GetByIdAsync(id, cancellationToken);
                return standard != null ? Results.Ok(standard) : Results.NotFound();
            })
            .WithTags(_tag);

            app.MapGet("/{id}/with-version", async (long id, IIsoStandardService service, CancellationToken cancellationToken) =>
            {
                var standard = await service.GetByIdWithVersionAsync(id, cancellationToken);
                return standard != null ? Results.Ok(standard) : Results.NotFound();
            })
            .WithTags(_tag);

            app.MapGet("/version/{versionId}", async (int versionId, IIsoStandardService service, CancellationToken cancellationToken) =>
            {
                var standards = await service.GetByVersionIdAsync(versionId, cancellationToken);
                return standards != null ? Results.Ok(standards) : Results.NoContent();
            })
            .WithTags(_tag);

            app.MapGet("/filter-clause/{clauseRef}", async (string clauseRef, IIsoStandardService service, CancellationToken cancellationToken) =>
            {
                const int noOfResults = 10;
                var standards = await service.FilterByClauseRef(clauseRef, noOfResults, cancellationToken);
                return standards != null ? Results.Ok(standards) : Results.NoContent();
            })
            .WithTags(_tag);

            app.MapGet("/paginate/{page}/{pageSize}", async (int page, int pageSize, IIsoStandardService service, CancellationToken cancellationToken) =>
            {
                var paginatedStandards = await service.GetPaginatedAsync(page, pageSize, cancellationToken);
                return Results.Ok(paginatedStandards);
            })
            .WithTags(_tag);

            app.MapGet("/paginate-version/{versionId}/{page}/{pageSize}", async (int versionId, int page, int pageSize, IIsoStandardService service, CancellationToken cancellationToken) =>
            {
                var paginatedStandards = await service.GetPaginatedByVersionAsync(versionId, page, pageSize, cancellationToken);
                return Results.Ok(paginatedStandards);
            })
            .WithTags(_tag);

            app.MapPut("/{id}", async (long id, [FromBody] IsoStandardDto dto, IIsoStandardService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existing = await service.GetByIdAsync(id, cancellationToken);
                if (existing == null)
                    return Results.NotFound($"IsoStandard with ID {id} not found.");
                dto.Id = id;
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);

            app.MapDelete("/{id:long}", async (long id, IIsoStandardService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_tag, cancellationToken);

                return result
                    ? Results.Ok(new { message = "IsoStandard deleted successfully." })
                    : Results.NotFound(new { message = "IsoStandard not found." });
            })
            .WithTags(_tag);
         

        }
    }
}
