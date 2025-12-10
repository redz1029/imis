using Base.Auths.Permissions;
using Carter;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.PgsKeyResultAreaModule;
using IMIS.Application.PgsKraModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.KraRoadMapPeriodModule
{
    public class KraRoadMapPeriodEndpoint : CarterModule
    {
        private const string _kraRoadMapPeriod = "Kra RoadMap Period";
        public readonly KraRoadMapPeriodPermission _kraRoadMapPeriodPermission = new();
        public KraRoadMapPeriodEndpoint() : base("/kraRoadMapPeriod")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] KraRoadMapPeriodDto kraRoadMapPeriodDto, IKraRoadMapPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(kraRoadMapPeriodDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_kraRoadMapPeriod, cancellationToken);
                return Results.Ok(kraRoadMapPeriodDto);
            })
            .WithTags(_kraRoadMapPeriod)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPeriodPermission.Add));

            app.MapGet("/", async (IKraRoadMapPeriodService service, CancellationToken cancellationToken) =>
            {
                var period = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(period);
            })
            .WithTags(_kraRoadMapPeriod)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_kraRoadMapPeriod), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPeriodPermission.View));

            app.MapGet("/{id}", async (int id, IKraRoadMapPeriodService service, CancellationToken cancellationToken) =>
            {
                var kraRoadMapPeriodDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return kraRoadMapPeriodDto != null ? Results.Ok(kraRoadMapPeriodDto) : Results.NotFound();
            })
            .WithTags(_kraRoadMapPeriod)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_kraRoadMapPeriod), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPeriodPermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] KraRoadMapPeriodDto kraRoadMapPeriodDto, IKraRoadMapPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {

                var existingkraRoadMapPeriodDto = await service.GetByIdAsync(id, cancellationToken);
                if (existingkraRoadMapPeriodDto == null)
                    return Results.NotFound($"Kra RoadMap Period with ID {id} not found.");

                kraRoadMapPeriodDto.Id = id;
                await service.SaveOrUpdateAsync(kraRoadMapPeriodDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_kraRoadMapPeriod, cancellationToken);
                return Results.Ok(kraRoadMapPeriodDto);

            })
            .WithTags(_kraRoadMapPeriod)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPeriodPermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IKraRoadMapPeriodService service, CancellationToken cancellationToken) =>
            {
                var paginatedkraRoadMapPeriodDto = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedkraRoadMapPeriodDto);
            })
           .WithTags(_kraRoadMapPeriod)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_kraRoadMapPeriod), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPeriodPermission.View));

            app.MapDelete("/{id:int}", async (int id, IKraRoadMapPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_kraRoadMapPeriod, cancellationToken);

                return result ? Results.Ok(new { message = "Kra RoadMap Period deleted successfully." })
                              : Results.NotFound(new { message = "Kra RoadMap Period not found." });
            })
         .WithTags(_kraRoadMapPeriod)
         .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPeriodPermission.Edit));
        }
    }
}
