using Base.Auths.Permissions;
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
        public readonly PgsSignatoryTemplatePermission _pgsSignatoryTemplatePermission = new();
        public PgsSignatoryTemplateEndPoints() : base("/pgsSignatoryTemplate")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
           
            app.MapPost("/", async ([FromBody] List<PgsSignatoryTemplateDto> pgsSignatoryTemplateDtos, IPgsSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SaveOrUpdateAsync(pgsSignatoryTemplateDtos, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_PgsSignatoryTemplate, cancellationToken);
                return Results.Ok("Records have been successfully saved.");
            })

            .WithTags(_PgsSignatoryTemplate)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _pgsSignatoryTemplatePermission.Add));

            app.MapGet("/", async (IPgsSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var pgsSignatoryTemplate = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(pgsSignatoryTemplate);
            })
            .WithTags(_PgsSignatoryTemplate)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_PgsSignatoryTemplate), true)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _pgsSignatoryTemplatePermission.View));

            app.MapGet("/{id}", async (int id, IPgsSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var pgsSignatoryTemplate = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return pgsSignatoryTemplate != null ? Results.Ok(pgsSignatoryTemplate) : Results.NotFound();
            })
            .WithTags(_PgsSignatoryTemplate)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_PgsSignatoryTemplate), true)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _pgsSignatoryTemplatePermission.View));
           

            app.MapPut("/", async ([FromBody] List<PgsSignatoryTemplateDto> pgsSignatoryTemplateDtos, IPgsSignatoryTemplateService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (pgsSignatoryTemplateDtos == null || !pgsSignatoryTemplateDtos.Any())
                {
                    return Results.BadRequest("No data provided for update.");
                }

               

                var updatedTemplates = await service.SaveOrUpdateAsync(pgsSignatoryTemplateDtos, cancellationToken).ConfigureAwait(false);

                await cache.EvictByTagAsync(_PgsSignatoryTemplate, cancellationToken);
                return Results.Ok(updatedTemplates);
            })
            .WithTags(_PgsSignatoryTemplate)
            .RequireAuthorization(e => e.RequireClaim(
                PermissionClaimType.Claim, _pgsSignatoryTemplatePermission.Edit));

            ;
            app.MapGet("/page", async (int page, int pageSize, IPgsSignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var paginatedSignatoryTemplate = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedSignatoryTemplate);
            })
           .WithTags(_PgsSignatoryTemplate)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_PgsSignatoryTemplate), true)
           .RequireAuthorization(e => e.RequireClaim(
           PermissionClaimType.Claim, _pgsSignatoryTemplatePermission.View));
        }
    }
}
