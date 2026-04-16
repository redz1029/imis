using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditScheduleModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Presentation.AuditScheduleModule
{
    public class AuditScheduleEndPoints : CarterModule
    {
        private const string _AuditSchedule = "AuditSchedule";
        // Assuming AuditSchedulePermission exists following your naming convention
        public readonly AuditSchedulePermission _permission = new();

        public AuditScheduleEndPoints() : base("/auditSchedule")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async (
                [FromBody] AuditScheduleDto dto,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                var result = await service.SaveAuditScheduleAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to save Audit Schedule.");
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // GET ALL
            app.MapGet("/", async (
                IAuditScheduleService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditSchedule)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET BY ID
            app.MapGet("/{id:int}", async (
                int id,
                IAuditScheduleService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);

                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_AuditSchedule)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // UPDATE
            app.MapPut("/{id:int}", async (
                int id,
                [FromBody] AuditScheduleDto dto,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                dto.Id = id;

                var result = await service.SaveAuditScheduleAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to update Audit Schedule.");
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // PAGINATION
            app.MapGet("/page", async (
                int page,
                int pageSize,
                IAuditScheduleService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditSchedule)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // DELETE (SOFT DELETE)
            app.MapDelete("/{id:int}", async (
                int id,
                IAuditScheduleService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                return result
                    ? Results.Ok(new { message = "Audit Schedule deleted successfully." })
                    : Results.NotFound(new { message = "Audit Schedule not found." });
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
        }
    }
}