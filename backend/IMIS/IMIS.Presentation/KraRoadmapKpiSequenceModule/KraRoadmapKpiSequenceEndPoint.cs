using Base.Auths.Permissions;
using Carter;
using IMIS.Application.KraRoadmapKpiSequenceModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.KraRoadmapKpiSequenceModule
{
    public class KraRoadmapKpiSequenceEndPoint : CarterModule
    {
        private const string _kraRoadmapKPISequence = "Kra Roadmap KPI Sequence";
        public readonly KraRoadmapKpiSequencePermission _kraRoadmapKpiSequencePermission = new();
        public KraRoadmapKpiSequenceEndPoint() : base("/KraRoadmapKPISequence")
        {        
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] KraRoadmapKpiSequenceDto kraRoadmapKpiSequenceDto, IKraRoadmapKpiSequenceService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(kraRoadmapKpiSequenceDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_kraRoadmapKPISequence, cancellationToken);
                return Results.Ok(kraRoadmapKpiSequenceDto);
            })
           .WithTags(_kraRoadmapKPISequence)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadmapKpiSequencePermission.Add));

            app.MapGet("/", async (IKraRoadmapKpiSequenceService service, CancellationToken cancellationToken) =>
            {
                var kraRoadmapKpiSequenceDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(kraRoadmapKpiSequenceDto);
            })
            .WithTags(_kraRoadmapKPISequence)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_kraRoadmapKPISequence), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadmapKpiSequencePermission.View));

            app.MapGet("/{id}", async (int id, IKraRoadmapKpiSequenceService service, CancellationToken cancellationToken) =>
            {
                var kraRoadmapKpiSequenceDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return kraRoadmapKpiSequenceDto != null ? Results.Ok(kraRoadmapKpiSequenceDto) : Results.NotFound();
            })
           .WithTags(_kraRoadmapKPISequence)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_kraRoadmapKPISequence), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadmapKpiSequencePermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] KraRoadmapKpiSequenceDto kraRoadmapKpiSequenceDto, IKraRoadmapKpiSequenceService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {

                var existingkraRoadmapKpiSequenceDto = await service.GetByIdAsync(id, cancellationToken);
                if (existingkraRoadmapKpiSequenceDto == null)
                    return Results.NotFound($"Kra RoadMap KPI with ID {id} not found.");

                kraRoadmapKpiSequenceDto.Id = id;
                await service.SaveOrUpdateAsync(kraRoadmapKpiSequenceDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_kraRoadmapKPISequence, cancellationToken);
                return Results.Ok(kraRoadmapKpiSequenceDto);

            })
           .WithTags(_kraRoadmapKPISequence)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadmapKpiSequencePermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IKraRoadmapKpiSequenceService service, CancellationToken cancellationToken) =>
            {
                var paginatedkraRoadmapKpiSequenceDto = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedkraRoadmapKpiSequenceDto);
            })
            .WithTags(_kraRoadmapKPISequence)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_kraRoadmapKPISequence), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadmapKpiSequencePermission.View));

            app.MapDelete("/{id:int}", async (int id, IKraRoadmapKpiSequenceService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_kraRoadmapKPISequence, cancellationToken);

                return result ? Results.Ok(new { message = "Kra RoadMap  deleted successfully." })
                              : Results.NotFound(new { message = "Kra RoadMap  not found." });
            })
        .WithTags(_kraRoadmapKPISequence)
        .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadmapKpiSequencePermission.Edit));
        }
    }
}
