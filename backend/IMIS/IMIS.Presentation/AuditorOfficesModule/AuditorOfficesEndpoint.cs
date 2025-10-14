using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditorOfficesModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditorOfficesModule
{
    public class AuditorOfficesEndpoint :  CarterModule
    {
        private const string _auditorOfficesTag = "AuditorOffices";
        public readonly AuditorOfficesPermission _auditorOfficePermission = new();
        public AuditorOfficesEndpoint() : base("/auditorsOffices")
        {
            
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] AuditorOfficesDto auditorOffices, IAuditorOfficesService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(auditorOffices, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditorOfficesTag, cancellationToken);
                return Results.Ok(auditorOffices);
            })
            .WithTags(_auditorOfficesTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorOfficePermission.Add));
          
            app.MapGet("/", async (IAuditorOfficesService service, CancellationToken cancellationToken) =>
            {
                var auditorsOffices = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(auditorsOffices);
            })
            .WithTags(_auditorOfficesTag).RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorOfficePermission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditorOfficesTag), true);

            app.MapPut("/{id}", async (int id, [FromBody] AuditorOfficesDto auditorOffice, IAuditorOfficesService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existingAuditorOffices = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingAuditorOffices == null)
                {
                    return Results.NotFound($"Auditor Offices with ID {id} not found.");
                }
                await service.SaveOrUpdateAsync(auditorOffice, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditorOfficesTag, cancellationToken);
                return Results.Ok(auditorOffice);
            })
           .WithTags(_auditorOfficesTag)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorOfficePermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IAuditorOfficesService service, CancellationToken cancellationToken) =>
            {
                var paginatedAuditorOffice = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedAuditorOffice);
            })
            .WithTags(_auditorOfficesTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditorOfficesTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorOfficePermission.View));

            app.MapDelete("/{id:int}", async (int id, IAuditorOfficesService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_auditorOfficesTag, cancellationToken);

                return result ? Results.Ok(new { message = "Auditor Office deleted successfully." })
                              : Results.NotFound(new { message = "Auditor Office not found." });
            })
            .WithTags(_auditorOfficesTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorOfficePermission.Edit));
        }
    }
}
