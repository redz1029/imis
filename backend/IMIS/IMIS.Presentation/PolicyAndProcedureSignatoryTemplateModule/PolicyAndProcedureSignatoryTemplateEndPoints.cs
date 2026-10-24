using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Application.PolicyAndProcedureSignatoryTemplateModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PolicyAndProcedureSignatoryTemplateModule
{
    public class PolicyAndProcedureSignatoryTemplateEndPoints : CarterModule
    {
        private const string _papSignatoryTemplate = "PAP Signatory Template";
        public PolicyAndProcedureSignatoryTemplateEndPoints() : base("/papSignatoryTemplate")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] List<PolicyAndProcedureSignatoryTemplateDto> papSignatoryTemplateDtos, IPolicyAndProcedureSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SaveOrUpdateAsync(papSignatoryTemplateDtos, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_papSignatoryTemplate, cancellationToken);
                return Results.Ok(papSignatoryTemplateDtos);
            })
           .WithTags(_papSignatoryTemplate);

            app.MapGet("/", async (IPolicyAndProcedureSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var papSignatoryTemplate = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(papSignatoryTemplate);
            })
          .WithTags(_papSignatoryTemplate)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_papSignatoryTemplate), true);

            app.MapGet("/{id}", async (int id, IPolicyAndProcedureSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var papSignatoryTemplate = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return papSignatoryTemplate != null ? Results.Ok(papSignatoryTemplate) : Results.NotFound();
            })
           .WithTags(_papSignatoryTemplate)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_papSignatoryTemplate), true);

            app.MapPut("/", async ([FromBody] List<PolicyAndProcedureSignatoryTemplateDto> papSignatoryTemplateDtos, IPolicyAndProcedureSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (papSignatoryTemplateDtos == null || !papSignatoryTemplateDtos.Any())
                {
                    return Results.BadRequest("No data provided for update.");
                }

                var updatedTemplates = await service.SaveOrUpdateAsync(papSignatoryTemplateDtos, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_papSignatoryTemplate, cancellationToken);
                return Results.Ok(updatedTemplates);
            })
           .WithTags(_papSignatoryTemplate);

            app.MapGet("/page", async (int page, int pageSize, IPolicyAndProcedureSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var papginatedSignatoryTemplate = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(papginatedSignatoryTemplate);
            })
            .WithTags(_papSignatoryTemplate)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_papSignatoryTemplate), true);

            app.MapDelete("/{id:int}", async (int id, IPolicyAndProcedureSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_papSignatoryTemplate, cancellationToken);

                return result ? Results.Ok(new { message = "Signatory Template deleted successfully." })
                              : Results.NotFound(new { message = "Signatory Template not found." });
            })
          .WithTags(_papSignatoryTemplate);
        }
    }
}
