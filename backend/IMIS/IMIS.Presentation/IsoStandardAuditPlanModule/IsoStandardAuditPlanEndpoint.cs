using Base.Auths.Permissions;
using Carter;
using IMIS.Application.IsoStandardAuditPlanModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.IsoStandardAuditPlanModule
{
    public class IsoStandardAuditPlanEndpoint : CarterModule
    {
        private const string _tag = "IsoStandardAuditPlans";
        // Assuming this permission class exists in your Auths/Permissions folder
        //public readonly IsoStandardAuditPlanPermission _permission = new();

        public IsoStandardAuditPlanEndpoint() : base("/isoStandardAuditPlans")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // --- CREATE / UPDATE ---
            app.MapPost("/", async ([FromBody] IsoStandardAuditPlanDto dto, IIsoStandardAuditPlanService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // --- READ ALL ---
            app.MapGet("/", async (IIsoStandardAuditPlanService service, CancellationToken cancellationToken) =>
            {
                var list = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(list);
            })
            .WithTags(_tag)
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_tag), true);

            // --- UPDATE BY ID ---
            app.MapPut("/{id:int}", async (int id, [FromBody] IsoStandardAuditPlanDto dto, IIsoStandardAuditPlanService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existing = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existing == null)
                {
                    return Results.NotFound($"ISO Standard Audit Plan with ID {id} not found.");
                }

                dto.Id = id; // Ensure ID consistency
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // --- READ PAGINATED ---
            app.MapGet("/page", async (int page, int pageSize, IIsoStandardAuditPlanService service, CancellationToken cancellationToken) =>
            {
                var paginated = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginated);
            })
            .WithTags(_tag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_tag), true);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // --- DELETE ---
            app.MapDelete("/{id:int}", async (int id, IIsoStandardAuditPlanService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);
                await cache.EvictByTagAsync(_tag, cancellationToken);

                return result ? Results.Ok(new { message = "Plan deleted successfully." })
                              : Results.NotFound(new { message = "Plan not found." });
            })
            .WithTags(_tag);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
        }
    }
}