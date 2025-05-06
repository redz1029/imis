using Carter;
using IMIS.Application.PgsSignatoryTemplateModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsSignatoryTemplateModule
{
    public class PgsSignatoryTemplateEndPoints : CarterModule
    {
        private const string _PgsSignatoryTemplate = "PGS Signatory Template";
        public PgsSignatoryTemplateEndPoints() : base("/pgsSignatoryTemplate")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PgsSignatoryTemplateDto pgsSignatoryTemplateDto, IPgsSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var createdUserOffice = await service.SaveOrUpdateAsync(pgsSignatoryTemplateDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_PgsSignatoryTemplate, cancellationToken);
                return Results.Ok("Record has been successfully saved.");
            })
            .WithTags(_PgsSignatoryTemplate);

            app.MapGet("/", async (IPgsSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var pgsSignatoryTemplate = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(pgsSignatoryTemplate);
            })
            .WithTags(_PgsSignatoryTemplate)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_PgsSignatoryTemplate), true);

            app.MapGet("/{id}", async (int id, IPgsSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var pgsSignatoryTemplate = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return pgsSignatoryTemplate != null ? Results.Ok(pgsSignatoryTemplate) : Results.NotFound();
            })
           .WithTags(_PgsSignatoryTemplate)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_PgsSignatoryTemplate), true);
            app.MapPut("/{id}", async (int id, [FromBody] PgsSignatoryTemplateDto pgsSignatoryTemplateDto, IPgsSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existingpgsSignatoryTemplate = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingpgsSignatoryTemplate == null)
                {
                    return Results.NotFound($"Team with ID {id} not found.");
                }
                var updatedSignatoryTemplate = await service.SaveOrUpdateAsync(pgsSignatoryTemplateDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_PgsSignatoryTemplate, cancellationToken);
                return Results.Ok(updatedSignatoryTemplate);
            })
           .WithTags(_PgsSignatoryTemplate);
            app.MapGet("/page", async (int page, int pageSize, IPgsSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var paginatedSignatoryTemplate = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedSignatoryTemplate);
            })
           .WithTags(_PgsSignatoryTemplate)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_PgsSignatoryTemplate), true);
        }
    }
}
