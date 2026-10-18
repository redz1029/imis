using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditPlanPersonResponsibleModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditPlanPersonResponsibleModule
{
    public class AuditPlanPersonResponsibleEndpoint : CarterModule
    {
        private const string _tag = "AuditPlanPersonResponsibles";
        // Assuming your permission class follows the standard naming convention
        //public readonly AuditPlanPersonResponsiblePermission _permission = new();

        public AuditPlanPersonResponsibleEndpoint() : base("/auditPlanPersonResponsibles")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // --- POST (Create or Update) ---
            app.MapPost("/", async ([FromBody] AuditPlanPersonResponsibleDto dto, IAuditPlanPersonResponsibleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // --- GET ALL ---
            app.MapGet("/", async (IAuditPlanPersonResponsibleService service, CancellationToken cancellationToken) =>
            {
                var list = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(list);
            })
            .WithTags(_tag)
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_tag), true);

            // --- GET PAGINATED ---
            app.MapGet("/page", async (int page, int pageSize, IAuditPlanPersonResponsibleService service, CancellationToken cancellationToken) =>
            {
                var paginated = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginated);
            })
            .WithTags(_tag)
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_tag), true);

            // --- PUT (Update by ID) ---
            app.MapPut("/{id:int}", async (int id, [FromBody] AuditPlanPersonResponsibleDto dto, IAuditPlanPersonResponsibleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existing = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existing == null)
                {
                    return Results.NotFound($"Responsible Person with ID {id} not found.");
                }

                dto.Id = id; // Maintain identity integrity
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // --- DELETE ---
            app.MapDelete("/{id:int}", async (int id, IAuditPlanPersonResponsibleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);
                await cache.EvictByTagAsync(_tag, cancellationToken);

                return result ? Results.Ok(new { message = "Responsible Person deleted successfully." })
                              : Results.NotFound(new { message = "Responsible Person not found." });
            })
            .WithTags(_tag);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
        }
    }
}