using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditProgrammeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Presentation.AuditProgrammeModule
{
    public class AuditProgrammeEndPoints : CarterModule
    {
        private const string _AuditProgramme = "AuditProgramme";
        //public readonly AuditProgrammePermission _permission = new();

        public AuditProgrammeEndPoints() : base("/auditProgramme")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async (
                [FromBody] AuditProgrammeDto dto,
                IAuditProgrammeService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                var result = await service.SaveAuditProgrammeAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to save Audit Programme.");
            })
            .WithTags(_AuditProgramme);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // GET ALL
            app.MapGet("/", async (
                IAuditProgrammeService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditProgramme)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditProgramme), true);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET BY ID
            app.MapGet("/{id:int}", async (
                int id,
                IAuditProgrammeService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);

                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_AuditProgramme)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditProgramme), true);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // UPDATE
            app.MapPut("/{id:int}", async (
                int id,
                [FromBody] AuditProgrammeDto dto,
                IAuditProgrammeService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                dto.Id = id;

                var result = await service.SaveAuditProgrammeAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to update Audit Programme.");
            })
            .WithTags(_AuditProgramme);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // PAGINATION
            app.MapGet("/page", async (
                int page,
                int pageSize,
                IAuditProgrammeService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditProgramme)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditProgramme), true);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // DELETE (SOFT DELETE)
            app.MapDelete("/{id:int}", async (
                int id,
                IAuditProgrammeService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken);

                return result
                    ? Results.Ok(new { message = "Audit Programme deleted successfully." })
                    : Results.NotFound(new { message = "Audit Programme not found." });
            })
            .WithTags(_AuditProgramme);
            //.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
        }
    }
}