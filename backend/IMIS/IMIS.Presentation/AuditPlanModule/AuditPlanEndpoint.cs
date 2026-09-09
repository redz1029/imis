using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditPlanModule;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Domain;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditPlanModule
{
    public class AuditPlanEndPoints : CarterModule
    {
        private const string _AuditPlan = "AuditPlan";
        public readonly AuditPlanPermission _permission = new();

        public AuditPlanEndPoints() : base("/auditPlan")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async (
                [FromBody] AuditPlanDto dto,
                IAuditPlanService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                var result = await service.SaveAuditPlanAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_AuditPlan, cancellationToken);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to save Audit Plan.");
            })
            .WithTags(_AuditPlan);//.RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Add));

            // GET BY PROGRAMME ID
            app.MapGet("/programme/{programmeId:int}", async (
                int programmeId,
                IAuditPlanService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByProgrammeIdAsync(programmeId, cancellationToken);
                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_AuditPlan)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlan), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));
            // GET ALL
            app.MapGet("/", async (
                IAuditPlanService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditPlan)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlan), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // GET BY ID
            app.MapGet("/{id:int}", async (
                int id,
                IAuditPlanService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);

                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_AuditPlan)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlan), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            // UPDATE
            app.MapPut("/{id:int}", async (
                int id,
                [FromBody] AuditPlanDto dto,
                IAuditPlanService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                dto.Id = id;

                var result = await service.SaveAuditPlanAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_AuditPlan, cancellationToken);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to update Audit Plan.");
            })
            .WithTags(_AuditPlan)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));

            // PAGINATION
            app.MapGet("/page", async (
                int page,
                int pageSize,
                IAuditPlanService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_AuditPlan)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlan), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.View));

            app.MapGet("/PdF/{id:int}", async (
                HttpResponse response,
                int id,
                IAuditPlanService service,
                CancellationToken cancellationToken) =>
            {
                var AuditData = await service.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);

                if (AuditData == null)
                    return Results.NotFound(new { message = $"Audit Plan with ID {id} was not found." });

                var file = await ReportUtil.GeneratePdfReport<ReportAuditPlanDto>(
                    "AuditPlan",
                    new List<ReportAuditPlanDto> { AuditData },
                    "AuditData",
                    cancellationToken
                ).ConfigureAwait(false);

                return Results.File(file, "application/pdf", $"AuditPlan_{DateTime.Now:yyyyMMddHHmmss}.pdf");
            })
            .WithTags(_AuditPlan)
            .RequireCors("_allowedOrigins")
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditPlan), true);

            // DELETE (SOFT DELETE)
            app.MapDelete("/{id:int}", async (
                int id,
                IAuditPlanService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_AuditPlan, cancellationToken);

                return result
                    ? Results.Ok(new { message = "Audit Plan deleted successfully." })
                    : Results.NotFound(new { message = "Audit Plan not found." });
            })
            .WithTags(_AuditPlan)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _permission.Edit));
        }
    }
}