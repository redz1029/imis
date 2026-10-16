using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditScheduleModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditScheduleModule
{
    public class AuditScheduleEndPoints : CarterModule
    {
        private const string _AuditSchedule = "AuditSchedule";
        public readonly AuditSchedulePermission _auditSchedulePermission = new();
        public AuditScheduleEndPoints() : base("/auditSchedule")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {

            app.MapPost("/", async ([FromBody] AuditScheduleDto auditScheduleDto, IAuditScheduleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (auditScheduleDto.AuditSchduleDetails == null || !auditScheduleDto.AuditSchduleDetails.Any())
                    return Results.BadRequest("No audit schedule details provided.");

                var overlapErrors = await service.GetOverlappingAuditAsync(auditScheduleDto, cancellationToken);
                if (overlapErrors.Count > 0)
                    return Results.BadRequest(new { Errors = overlapErrors });

                await service.SaveOrUpdateAsync(auditScheduleDto, cancellationToken);
                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                return Results.Ok(auditScheduleDto);
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditSchedulePermission.Add));

            app.MapGet("/", async (IAuditScheduleService service, CancellationToken cancellationToken) =>
            {
                var auditScheduleDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(auditScheduleDto);
            })
           .WithTags(_AuditSchedule)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditSchedulePermission.View));

            app.MapGet("/{id}", async (int id, IAuditScheduleService service, CancellationToken cancellationToken) =>
            {
                var auditScheduleDto = await service.GetByAuditScheduleIdAsync(id, cancellationToken).ConfigureAwait(false);
                return auditScheduleDto != null ? Results.Ok(auditScheduleDto) : Results.NotFound();
            })
           .WithTags(_AuditSchedule)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditSchedulePermission.Edit));

            app.MapPut("/{id:int}", async (int id, [FromBody] AuditScheduleDto auditScheduleDto, IAuditScheduleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (auditScheduleDto.AuditSchduleDetails == null || !auditScheduleDto.AuditSchduleDetails.Any())
                    return Results.BadRequest("No audit schedule details provided.");

                var overlapErrors = await service.GetOverlappingAuditAsync(auditScheduleDto, cancellationToken);
                if (overlapErrors.Count > 0)
                    return Results.BadRequest(new { Errors = overlapErrors });

                auditScheduleDto.Id = id;

                await service.SaveOrUpdateAsync(auditScheduleDto, cancellationToken);

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                return Results.Ok(auditScheduleDto);
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditSchedulePermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IAuditScheduleService service, CancellationToken cancellationToken) =>
            {
                var paginatedAuditSchedule = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedAuditSchedule);
            })
           .WithTags(_AuditSchedule)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditSchedulePermission.View));

            app.MapDelete("/{id:int}", async (int id, IAuditScheduleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                return result ? Results.Ok(new { message = "Audit Schedule deleted successfully." })
                              : Results.NotFound(new { message = "Audit Schedule not found." });
            })
            .WithTags(_AuditSchedule)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditSchedulePermission.Edit));

            app.MapDelete("/AuditScheduleDetails{id:int}", async (int id, IAuditScheduleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAuditScheduleDetailsAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                return result ? Results.Ok(new { message = "Audit Schedule Detail deleted successfully." })
                              : Results.NotFound(new { message = "Audit Schedule Detail not found." });
            })
          .WithTags(_AuditSchedule)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditSchedulePermission.Edit));
        }
    }
}
