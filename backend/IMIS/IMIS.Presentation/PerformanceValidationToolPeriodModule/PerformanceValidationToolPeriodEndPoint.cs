using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PerformanceValidationToolPeriodModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PerformanceValidationToolPeriodModule
{
    public class PerformanceValidationToolPeriodEndPoint : CarterModule
    {
        private const string _performanceValidationToolPeriod = "Performance ValidationTool Period";
        public readonly PerformanceValidationToolPeriodPermission _performanceValidationToolPeriodPermission = new();
        public PerformanceValidationToolPeriodEndPoint() : base("/performanceValidationToolPeriod")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PerformanceValidationToolPeriodDto performanceValidationToolPeriodDto, IPerformanceValidationToolPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(performanceValidationToolPeriodDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_performanceValidationToolPeriod, cancellationToken);
                return Results.Ok(performanceValidationToolPeriodDto);
            })
           .WithTags(_performanceValidationToolPeriod)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPeriodPermission.Add));
            
            app.MapGet("/", async (IPerformanceValidationToolPeriodService service, CancellationToken cancellationToken) =>
            {
                var period = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(period);
            })
           .WithTags(_performanceValidationToolPeriod)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationToolPeriod), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPeriodPermission.View));

            app.MapGet("/{id}", async (int id, IPerformanceValidationToolPeriodService service, CancellationToken cancellationToken) =>
            {
                var performanceValidationToolPeriodDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return performanceValidationToolPeriodDto != null ? Results.Ok(performanceValidationToolPeriodDto) : Results.NotFound();
            })
           .WithTags(_performanceValidationToolPeriod)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationToolPeriod), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPeriodPermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] PerformanceValidationToolPeriodDto performanceValidationToolPeriodDto, IPerformanceValidationToolPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                try
                {
                    var existingPeriod = await service.GetByIdAsync(id, cancellationToken);
                    if (existingPeriod == null)
                        return Results.NotFound($"PVT Period with ID {id} not found.");

                    performanceValidationToolPeriodDto.Id = id;
                    await service.SaveOrUpdateAsync(performanceValidationToolPeriodDto, cancellationToken).ConfigureAwait(false);
                    await cache.EvictByTagAsync(_performanceValidationToolPeriod, cancellationToken);
                    return Results.Ok(performanceValidationToolPeriodDto);


                }
                catch (InvalidOperationException ex) when (ex.InnerException is DbUpdateConcurrencyException)
                {
                    return Results.Conflict("The record was modified by another user. Please reload and try again.");
                }
            })
           .WithTags(_performanceValidationToolPeriod)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPeriodPermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IPerformanceValidationToolPeriodService service, CancellationToken cancellationToken) =>
            {
                var paginatedPvtPeriod = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedPvtPeriod);
            })
            .WithTags(_performanceValidationToolPeriod)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationToolPeriod), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPeriodPermission.View));

            app.MapDelete("/{id:int}", async (int id, IPerformanceValidationToolPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_performanceValidationToolPeriod, cancellationToken);

                return result ? Results.Ok(new { message = "PVT Period deleted successfully." })
                              : Results.NotFound(new { message = "PVT Period not found." });
            })
            .WithTags(_performanceValidationToolPeriod)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPeriodPermission.Edit));
        }
    }
}
