using Base.Auths.Permissions;
using Carter;
using IMIS.Application.KraRoadMapModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.KraRoadMapModule
{
    public class KraRoadMapEndPoint : CarterModule
    {
        private const string _kraRoadMap = "Kra Roadmap";
        public readonly KraRoadMapPermission _kraRoadMapPermission = new();
        public KraRoadMapEndPoint() : base("/kraRoadMap")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {

            app.MapPost("/", async ([FromBody] KraRoadMapDto dto, IKraRoadMapService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_kraRoadMap, cancellationToken);
                return Results.Ok(dto);
            })
           .WithTags(_kraRoadMap)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPermission.Add));

            app.MapGet("/", async (IKraRoadMapService service, CancellationToken cancellationToken) =>
            {
                var kraRoadMapDto = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(kraRoadMapDto);
            })
           .WithTags(_kraRoadMap)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_kraRoadMap), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPermission.View));

            app.MapGet("/{id}", async (int id, IKraRoadMapService service, CancellationToken cancellationToken) =>
            {
                var kraRoadMapDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return kraRoadMapDto != null ? Results.Ok(kraRoadMapDto) : Results.NotFound();
            })
            .WithTags(_kraRoadMap)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_kraRoadMap), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] KraRoadMapDto kraRoadMapDto, IKraRoadMapService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existingkraRoadMapDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                await service.SaveOrUpdateAsync(kraRoadMapDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_kraRoadMap, cancellationToken);
                return Results.Ok(kraRoadMapDto);
            })
           .WithTags(_kraRoadMap)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IKraRoadMapService service, CancellationToken cancellationToken) =>
            {
                var paginatedkraRoadMapDto = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedkraRoadMapDto);
            })
            .WithTags(_kraRoadMap)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_kraRoadMap), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPermission.View));

            app.MapDelete("/{id:int}", async (int id, IKraRoadMapService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_kraRoadMap, cancellationToken);

                return result ? Results.Ok(new { message = "Deleted successfully." })
                              : Results.NotFound(new { message = "RoadMap not found." });
            })
          .WithTags(_kraRoadMap)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPermission.Edit));


        }
    }
}
