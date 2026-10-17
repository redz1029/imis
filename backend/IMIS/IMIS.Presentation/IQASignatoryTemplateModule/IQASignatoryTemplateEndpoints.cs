using Carter;
using IMIS.Application.IQASignatoryTemplateModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.IQASignatoryTemplateModule
{
    public class IQASignatoryTemplateEndpoints : CarterModule
    {
        private const string _iqaSignatoryTemplate = "IQASignatoryTemplate";

        public IQASignatoryTemplateEndpoints()
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("IQASignatoryTemplate")
                           .WithTags(_iqaSignatoryTemplate);

            // CREATE / UPDATE
            group.MapPost("/", async (
                [FromBody] IQASignatoryTemplateDto dto,
                IIQASignatoryTemplateService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null) return Results.BadRequest("Request body is required.");

                var saved = await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_iqaSignatoryTemplate, cancellationToken).ConfigureAwait(false);

                return Results.Ok(saved);
            });

            // GET ALL
            group.MapGet("/", async (IIQASignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return result is not null && result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_iqaSignatoryTemplate));

            // GET PAGINATED
            group.MapGet("/paginated", async (
                [FromQuery] int page,
                [FromQuery] int pageSize,
                IIQASignatoryTemplateService service,
                CancellationToken cancellationToken) =>
            {
                if (page <= 0 || pageSize <= 0)
                    return Results.BadRequest("Page parameters must be positive.");

                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_iqaSignatoryTemplate));

            // GET BY ID
            group.MapGet("/{id:int}", async (int id, IIQASignatoryTemplateService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_iqaSignatoryTemplate));

            // GET BY AUDIT ENTITY TYPE
            group.MapGet("/type/{auditEntityType}", async (
                string auditEntityType,
                IIQASignatoryTemplateService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByAuditEntityTypeAsync(auditEntityType, cancellationToken).ConfigureAwait(false);
                return result is not null && result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_iqaSignatoryTemplate));

            // GET BY OFFICE ID
            group.MapGet("/office/{officeId:int}", async (
                int officeId,
                IIQASignatoryTemplateService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByOfficeIdAsync(officeId, cancellationToken).ConfigureAwait(false);
                return result is not null && result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_iqaSignatoryTemplate));

            // GET BY STATUS
            group.MapGet("/status/{status}", async (
                string status,
                IIQASignatoryTemplateService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByStatusAsync(status, cancellationToken).ConfigureAwait(false);
                return result is not null && result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_iqaSignatoryTemplate));

            // SOFT DELETE
            group.MapDelete("/{id:int}", async (
                int id,
                IIQASignatoryTemplateService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound(new { message = "Signatory template not found." });

                await cache.EvictByTagAsync(_iqaSignatoryTemplate, cancellationToken).ConfigureAwait(false);
                return Results.Ok(new { message = "Signatory template deleted successfully." });
            });
        }
    }
}