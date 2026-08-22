using Base.Auths.Permissions;
using Carter;
using IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.SWOTAnalysisOpportunitiesThreatsModule
{
    public class SWOTAnalysisOpportunitiesThreatsSettingsEndPoint : CarterModule
    {
        private const string _sWOTAnalysisOpportunitiesThreats = "SWOT Analysis Opportunities Threats";
        public readonly SWOTAnalysisOpportunitiesThreatsSettingsPermission _sWOTAnalysisOpportunitiesThreatsPermission = new();
        public SWOTAnalysisOpportunitiesThreatsSettingsEndPoint() : base("/SWOTAnalysisOpportunitiesThreats")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] SWOTAnalysisOpportunitiesThreatsSettingsDto sWOTAnalysisOpportunitiesThreatsDto, ISWOTAnalysisOpportunitiesThreatsSettingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(sWOTAnalysisOpportunitiesThreatsDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_sWOTAnalysisOpportunitiesThreats, cancellationToken);
                return Results.Ok(sWOTAnalysisOpportunitiesThreatsDto);
            })
          .WithTags(_sWOTAnalysisOpportunitiesThreats)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _sWOTAnalysisOpportunitiesThreatsPermission.Add));

            app.MapGet("/", async (ISWOTAnalysisOpportunitiesThreatsSettingsService service, CancellationToken cancellationToken) =>
            {
                var dto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(dto);
            })
          .WithTags(_sWOTAnalysisOpportunitiesThreats)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_sWOTAnalysisOpportunitiesThreats), true)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _sWOTAnalysisOpportunitiesThreatsPermission.View));


            app.MapPut("/{id}", async (int id, [FromBody] SWOTAnalysisOpportunitiesThreatsSettingsDto sWOTAnalysisOpportunitiesThreatsDto, ISWOTAnalysisOpportunitiesThreatsSettingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                try
                {
                    var existingPeriod = await service.GetByIdAsync(id, cancellationToken);
                    if (existingPeriod == null)
                        return Results.NotFound($"SWOT with ID {id} not found.");

                    sWOTAnalysisOpportunitiesThreatsDto.Id = id;
                    await service.SaveOrUpdateAsync(sWOTAnalysisOpportunitiesThreatsDto, cancellationToken).ConfigureAwait(false);
                    await cache.EvictByTagAsync(_sWOTAnalysisOpportunitiesThreats, cancellationToken);
                    return Results.Ok(sWOTAnalysisOpportunitiesThreatsDto);


                }
                catch (InvalidOperationException ex) when (ex.InnerException is DbUpdateConcurrencyException)
                {
                    return Results.Conflict("The record was modified by another user. Please reload and try again.");
                }
            })
            .WithTags(_sWOTAnalysisOpportunitiesThreats)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _sWOTAnalysisOpportunitiesThreatsPermission.Edit));


            app.MapGet("/page", async (int page, int pageSize, ISWOTAnalysisOpportunitiesThreatsSettingsService service, CancellationToken cancellationToken) =>
            {
                var paginatedSWOT = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedSWOT);
            })
            .WithTags(_sWOTAnalysisOpportunitiesThreats)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_sWOTAnalysisOpportunitiesThreats), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _sWOTAnalysisOpportunitiesThreatsPermission.View));

            app.MapDelete("/{id:int}", async (int id, ISWOTAnalysisOpportunitiesThreatsSettingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_sWOTAnalysisOpportunitiesThreats, cancellationToken);

                return result ? Results.Ok(new { message = "SWOT deleted successfully." })
                              : Results.NotFound(new { message = "SWOT not found." });
            })
            .WithTags(_sWOTAnalysisOpportunitiesThreats)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _sWOTAnalysisOpportunitiesThreatsPermission.Delete));
        }
    }
}
