using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PerformanceValidationToolSignatoryTemplateModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PerformanceValidationToolSignatoryTemplateModule
{
    public class PerformanceValidationToolSignatoryTemplateEndPoint : CarterModule
    {
        private const string _pvtSignatoryTemplate = "Performance Validation Tool Signatory Template";
        public readonly PerformanceValidationToolSignatoryTemplatePermission _pvtSignatoryTemplatePermission = new();
        public PerformanceValidationToolSignatoryTemplateEndPoint() : base("/performanceValidationToolSignatoryTemplate")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] List<PerformanceValidationToolSignatoryTemplateDto> pvtSignatoryTemplateDtos, IPerformanceValidationToolSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SaveOrUpdateAsync(pvtSignatoryTemplateDtos, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pvtSignatoryTemplate, cancellationToken);
                return Results.Ok(pvtSignatoryTemplateDtos);
            })
           .WithTags(_pvtSignatoryTemplate)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pvtSignatoryTemplatePermission.Add));

            app.MapGet("/", async (IPerformanceValidationToolSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var pvtSignatoryTemplate = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(pvtSignatoryTemplate);
            })
          .WithTags(_pvtSignatoryTemplate)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_pvtSignatoryTemplate), true)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pvtSignatoryTemplatePermission.View));

            app.MapGet("/{id}", async (int id, IPerformanceValidationToolSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var pvtSignatoryTemplateDtos = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return pvtSignatoryTemplateDtos != null ? Results.Ok(pvtSignatoryTemplateDtos) : Results.NotFound();
            })
            .WithTags(_pvtSignatoryTemplate)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_pvtSignatoryTemplate), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pvtSignatoryTemplatePermission.View));

            app.MapPut("/", async ([FromBody] List<PerformanceValidationToolSignatoryTemplateDto> pvtSignatoryTemplateDtos, IPerformanceValidationToolSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {  
                if (pvtSignatoryTemplateDtos == null || !pvtSignatoryTemplateDtos.Any())
                {
                    return Results.BadRequest("No data provided for update.");
                }

                var updatedTemplates = await service.SaveOrUpdateAsync(pvtSignatoryTemplateDtos, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pvtSignatoryTemplate, cancellationToken);
                return Results.Ok(updatedTemplates);
            })
           .WithTags(_pvtSignatoryTemplate);

            app.MapGet("/page", async (int page, int pageSize, IPerformanceValidationToolSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var paginatedSignatoryTemplate = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedSignatoryTemplate);
            })
            .WithTags(_pvtSignatoryTemplate)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_pvtSignatoryTemplate), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pvtSignatoryTemplatePermission.View));

            app.MapDelete("/{id:int}", async (int id, IPerformanceValidationToolSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_pvtSignatoryTemplate, cancellationToken);

                return result ? Results.Ok(new { message = "Signatory Template deleted successfully." })
                              : Results.NotFound(new { message = "Signatory Template not found." });
            })
          .WithTags(_pvtSignatoryTemplate);
        }
    }
}
