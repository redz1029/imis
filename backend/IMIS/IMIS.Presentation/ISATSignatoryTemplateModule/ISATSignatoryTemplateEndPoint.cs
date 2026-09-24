using Base.Auths.Permissions;
using Carter;
using IMIS.Application.ISATSignatoryTemplateModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.ISATSignatoryTemplateModule
{
    public class ISATSignatoryTemplateEndPoint : CarterModule
    {
        private const string _isatSignatoryTemplate = "ISAT Signatory Template";
        public readonly ISATSignatoryTemplatePermission _isatSignatoryTemplatePermission = new();
        public ISATSignatoryTemplateEndPoint() : base("/iSATSignatoryTemplate")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] List<ISATSignatoryTemplateDto> isatSignatoryTemplateDtos, IISATSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SaveOrUpdateAsync(isatSignatoryTemplateDtos, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_isatSignatoryTemplate, cancellationToken);
                return Results.Ok(isatSignatoryTemplateDtos);
            })
            .WithTags(_isatSignatoryTemplate)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _isatSignatoryTemplatePermission.Add));

            app.MapGet("/", async (IISATSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var isatSignatoryTemplate = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(isatSignatoryTemplate);
            })
            .WithTags(_isatSignatoryTemplate)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_isatSignatoryTemplate), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _isatSignatoryTemplatePermission.View));

            app.MapGet("/{id}", async (int id, IISATSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var isatSignatoryTemplateDtos = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return isatSignatoryTemplateDtos != null ? Results.Ok(isatSignatoryTemplateDtos) : Results.NotFound();
            })
            .WithTags(_isatSignatoryTemplate)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_isatSignatoryTemplate), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _isatSignatoryTemplatePermission.View));

            app.MapPut("/", async ([FromBody] List<ISATSignatoryTemplateDto> pvtSignatoryTemplateDtos, IISATSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (pvtSignatoryTemplateDtos == null || !pvtSignatoryTemplateDtos.Any())
                {
                    return Results.BadRequest("No data provided for update.");
                }

                var updatedTemplates = await service.SaveOrUpdateAsync(pvtSignatoryTemplateDtos, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_isatSignatoryTemplate, cancellationToken);
                return Results.Ok(updatedTemplates);
            })
            .WithTags(_isatSignatoryTemplate)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _isatSignatoryTemplatePermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IISATSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var paginatedSignatoryTemplate = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedSignatoryTemplate);
            })
            .WithTags(_isatSignatoryTemplate)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_isatSignatoryTemplate), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _isatSignatoryTemplatePermission.View));

            app.MapDelete("/{id:int}", async (int id, IISATSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_isatSignatoryTemplate, cancellationToken);

                return result ? Results.Ok(new { message = "Signatory Template deleted successfully." })
                              : Results.NotFound(new { message = "Signatory Template not found." });
            })
            .WithTags(_isatSignatoryTemplate)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _isatSignatoryTemplatePermission.Delete));
        }
    }
}
