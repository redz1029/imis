using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditPlanEntryModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditPlanEntryModule
{
    public class AuditPlanEntryEndPoints : CarterModule
    {
        private const string _AuditPlanEntry = "AuditPlanEntry";
        public readonly AuditPlanEntryPermission _permission = new();

        public AuditPlanEntryEndPoints() : base("/auditPlanEntry")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async (
                [FromBody] AuditPlanEntryDto dto,
                IAuditPlanEntryService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                var result = await service.SaveAuditPlanEntryDetailsAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_AuditPlanEntry, cancellationToken);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to save Audit Plan Entry.");
            })
            .WithTags(_AuditPlanEntry)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // GET ALL
            app.MapGet("/", async (
                IAuditPlanEntryService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditPlanEntry)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlanEntry), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET BY ID
            app.MapGet("/{id:int}", async (
                int id,
                IAuditPlanEntryService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByAuditPlanEntryIdAsync(id, cancellationToken);

                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_AuditPlanEntry)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlanEntry), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET BY AUDIT PLAN ID
            app.MapGet("/by-audit-plan/{auditPlanId:int}", async (
                int auditPlanId,
                IAuditPlanEntryService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllByAuditPlanIdAsync(auditPlanId, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditPlanEntry)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlanEntry), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // UPDATE
            app.MapPut("/{id:int}", async (
                int id,
                [FromBody] AuditPlanEntryDto dto,
                IAuditPlanEntryService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                dto.Id = id;

                var result = await service.SaveAuditPlanEntryDetailsAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_AuditPlanEntry, cancellationToken);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to update Audit Plan Entry.");
            })
            .WithTags(_AuditPlanEntry)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // PAGINATION
            app.MapGet("/page", async (
                int page,
                int pageSize,
                IAuditPlanEntryService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditPlanEntry)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlanEntry), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // DELETE (SOFT DELETE)
            app.MapDelete("/{id:int}", async (
                int id,
                IAuditPlanEntryService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_AuditPlanEntry, cancellationToken);

                return result
                    ? Results.Ok(new { message = "Audit Plan Entry deleted successfully." })
                    : Results.NotFound(new { message = "Audit Plan Entry not found." });
            })
            .WithTags(_AuditPlanEntry)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
        }
    }
}