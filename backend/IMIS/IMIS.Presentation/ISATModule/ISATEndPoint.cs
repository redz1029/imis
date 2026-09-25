using Base.Auths.Permissions;
using Carter;
using IMIS.Application.ISATModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.ISATModule
{
    public class ISATEndPoint : CarterModule
    {
        private const string _iSAT = "ISAT";
        public readonly ISATPermission _iSATPermission = new();
        public ISATEndPoint() : base("/ISAT")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] ISATDto dto, IISATService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_iSAT, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_iSAT)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _iSATPermission.Draft));

            app.MapGet("/{id:long}", async (long id, IISATService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);
                return result is null ? Results.NotFound() : Results.Ok(result);
            })
            .WithTags(_iSAT)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_iSAT), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _iSATPermission.View));

            app.MapPut("/", async ([FromBody] ISATDto dto, IISATService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_iSAT, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_iSAT)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_iSAT), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _iSATPermission.Edit));

            app.MapGet("/employee/{userId}", async (string userId, IISATService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetEmployeeProfileByUserIdAsync(userId, cancellationToken);
                return result is null ? Results.NotFound() : Results.Ok(result);
            })
            .WithTags(_iSAT)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_iSAT), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _iSATPermission.View));

            app.MapGet("/user/{userId}/{roleId}", async (string userId, string roleId, int? officeId, int page, int pageSize, IISATService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedByUserIdAsync(userId, roleId, officeId, page, pageSize, cancellationToken);
                return result is null ? Results.NotFound() : Results.Ok(result);
            })
            .WithTags(_iSAT)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_iSAT), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _iSATPermission.View));

            app.MapGet("/roadmap", async (IISATService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetRoadMapListAsync(cancellationToken);
                return Results.Ok(result);
            })
           .WithTags(_iSAT)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_iSAT), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _iSATPermission.View));

            app.MapGet("/roadmap/{roadMapId:long}/deliverables/{year:int}", async (long roadMapId, int year, IISATService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetDeliverablesByRoadMapIdAndYearAsync(roadMapId, year, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_iSAT)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_iSAT), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _iSATPermission.View));

            app.MapGet("/pgs-deliverables/{officeId:int}/{periodId:int}", async (int officeId, int periodId, IISATService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPgsDeliverablesByOfficeAndPeriodAsync(officeId, periodId, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_iSAT)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_iSAT), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _iSATPermission.View));

            app.MapPost("/submit/{userId}", async (string userId, [FromBody] ISATDto dto, IISATService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                try
                {
                    var result = await service.Submit(dto, userId, cancellationToken);
                    await cache.EvictByTagAsync(_iSAT, cancellationToken);
                    return Results.Ok(result);
                }
                catch (UnauthorizedAccessException ex)
                {
                    return Results.Json(new { message = ex.Message }, statusCode: StatusCodes.Status403Forbidden);
                }
                catch (InvalidOperationException ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            })
           .WithTags(_iSAT)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _iSATPermission.Submit));
        }
    }
}
