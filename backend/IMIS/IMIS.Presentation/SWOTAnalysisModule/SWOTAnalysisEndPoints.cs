using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.SWOTAnalysisModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.SWOTAnalysisModule
{
    public class SWOTAnalysisEndPoints : CarterModule
    {
        private const string _swotAnalysisTag = "SWOT Analysis";
        public readonly SWOTAnalysisPermission _swotAnalysisPermission = new();
        public SWOTAnalysisEndPoints() : base("/swotAnalysis")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] SWOTAnalysisDto swotAnalysisDto, ISWOTAnalysisService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(swotAnalysisDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_swotAnalysisTag, cancellationToken);
                return Results.Ok(swotAnalysisDto);
            })
           .WithTags(_swotAnalysisTag)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _swotAnalysisPermission.Add));
           
            app.MapGet("userId/{userId}", async (string userId, ISWOTAnalysisService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByUserIdAsync(userId, cancellationToken).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_swotAnalysisTag).CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_swotAnalysisTag),true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _swotAnalysisPermission.View));

            app.MapGet("/{id}", async (int id, ISWOTAnalysisService service, CancellationToken cancellationToken) =>
            {
                var swotAnalysisDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return swotAnalysisDto != null ? Results.Ok(swotAnalysisDto) : Results.NotFound();
            })
            .WithTags(_swotAnalysisTag)         
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_swotAnalysisTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _swotAnalysisPermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] SWOTAnalysisDto swotAnalysisDto, ISWOTAnalysisService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existingPeriod = await service.GetByIdAsync(id, cancellationToken);
                if (existingPeriod == null)
                    return Results.NotFound($"SWOT Analysis with ID {id} not found.");

                swotAnalysisDto.Id = id;
                await service.SaveOrUpdateAsync(swotAnalysisDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_swotAnalysisTag, cancellationToken);
                return Results.Ok(swotAnalysisDto);
                
            })
            .WithTags(_swotAnalysisTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _swotAnalysisPermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, ISWOTAnalysisService service, CancellationToken cancellationToken) =>
            {
                var paginatedswotAnalysisDto = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedswotAnalysisDto);
            })
            .WithTags(_swotAnalysisTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_swotAnalysisTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _swotAnalysisPermission.View));

            app.MapDelete("/{id:int}", async (int id, ISWOTAnalysisService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_swotAnalysisTag, cancellationToken);

                return result ? Results.Ok(new { message = "SWOT Analysis deleted successfully." })
                              : Results.NotFound(new { message = "SWOT Analysis not found." });
            })
            .WithTags(_swotAnalysisTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _swotAnalysisPermission.Edit));


        }
    }
}
