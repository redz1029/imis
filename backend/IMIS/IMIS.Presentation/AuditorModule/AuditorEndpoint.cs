using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditorModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditorModule
{
    public class AuditorEndpoint : CarterModule
    {
        private const string _auditorTag = "Auditor";
        public readonly AuditorPermission _auditorPermission = new();
        public AuditorEndpoint() : base("/auditors")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] AuditorDto auditor, IAuditorService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(auditor, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditorTag, cancellationToken);
                return Results.Ok(auditor);
            })
            .WithTags(_auditorTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorPermission.Add));

            app.MapGet("/", async (IAuditorService service, CancellationToken cancellationToken) =>
            {
                var auditors = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(auditors);
            })
            .WithTags(_auditorTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditorTag), true)            
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorPermission.View));

            app.MapGet("/filter/{name}", async (string name, IAuditorService service, CancellationToken cancellationToken) =>
            {
                int noOfResults = 10;
                var auditors = await service.FilteByName(name, noOfResults, cancellationToken).ConfigureAwait(false);
                return auditors != null ? Results.Ok(auditors) : Results.NoContent();
            })
            .WithTags(_auditorTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditorTag), true);

            app.MapGet("/{id}", async (int id, IAuditorService service, CancellationToken cancellationToken) =>
            {
                var auditor = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return auditor != null ? Results.Ok(auditor) : Results.NotFound();
            })
            .WithTags(_auditorTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditorTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorPermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] AuditorDto auditor, IAuditorService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {               
                var existingAuditor = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingAuditor == null)
                {
                    return Results.NotFound($"Auditor with ID {id} not found.");
                }
                await service.SaveOrUpdateAsync(auditor, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditorTag, cancellationToken);
                return Results.Ok(auditor);
            })
           .WithTags(_auditorTag)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorPermission.Edit));   
            
            app.MapGet("/page", async (int page, int pageSize, IAuditorService service, CancellationToken cancellationToken) =>
            {
                var paginatedAuditor = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedAuditor);
            })
          .WithTags(_auditorTag)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditorTag), true)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorPermission.View));

            app.MapDelete("/{id:int}", async (int id, IAuditorService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_auditorTag, cancellationToken);

                return result ? Results.Ok(new { message = "Auditor deleted successfully." })
                              : Results.NotFound(new { message = "Auditor not found." });
            })
           .WithTags(_auditorTag)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorPermission.Edit));
        }
    }
}
