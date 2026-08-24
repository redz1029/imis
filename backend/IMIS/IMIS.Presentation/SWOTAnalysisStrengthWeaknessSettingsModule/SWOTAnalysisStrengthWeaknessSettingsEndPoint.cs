
using Base.Auths.Permissions;
using Carter;
using IMIS.Application.SWOTAnalysisStrengthWeaknessModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.SWOTAnalysisStrengthWeaknessModule
{
    public class SWOTAnalysisStrengthWeaknessSettingsEndPoint : CarterModule
    {
        private const string _sWOTAnalysisStrengthWeakness = "SWOT Analysis Strength Weakness";
        public SWOTAnalysisStrengthWeaknessSettingsEndPoint() : base("/SWOTAnalysisStrengthWeakness")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] SWOTAnalysisStrengthWeaknessSettingsDto sWOTAnalysisStrengthWeaknessDto, ISWOTAnalysisStrengthWeaknessSettingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(sWOTAnalysisStrengthWeaknessDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_sWOTAnalysisStrengthWeakness, cancellationToken);
                return Results.Ok(sWOTAnalysisStrengthWeaknessDto);
            })
          .WithTags(_sWOTAnalysisStrengthWeakness);

            app.MapGet("/", async (ISWOTAnalysisStrengthWeaknessSettingsService service, CancellationToken cancellationToken) =>
            {
                var dto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(dto);
            })
          .WithTags(_sWOTAnalysisStrengthWeakness)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_sWOTAnalysisStrengthWeakness), true);


            app.MapPut("/{id}", async (int id, [FromBody] SWOTAnalysisStrengthWeaknessSettingsDto sWOTAnalysisStrengthWeaknessDto, ISWOTAnalysisStrengthWeaknessSettingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                try
                {
                    var existingPeriod = await service.GetByIdAsync(id, cancellationToken);
                    if (existingPeriod == null)
                        return Results.NotFound($"SWOT with ID {id} not found.");

                    sWOTAnalysisStrengthWeaknessDto.Id = id;
                    await service.SaveOrUpdateAsync(sWOTAnalysisStrengthWeaknessDto, cancellationToken).ConfigureAwait(false);
                    await cache.EvictByTagAsync(_sWOTAnalysisStrengthWeakness, cancellationToken);
                    return Results.Ok(sWOTAnalysisStrengthWeaknessDto);


                }
                catch (InvalidOperationException ex) when (ex.InnerException is DbUpdateConcurrencyException)
                {
                    return Results.Conflict("The record was modified by another user. Please reload and try again.");
                }
            })
            .WithTags(_sWOTAnalysisStrengthWeakness);

            app.MapGet("/page", async (int page, int pageSize, ISWOTAnalysisStrengthWeaknessSettingsService service, CancellationToken cancellationToken) =>
            {
                var paginatedSWOT = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedSWOT);
            })
            .WithTags(_sWOTAnalysisStrengthWeakness)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_sWOTAnalysisStrengthWeakness), true);

            app.MapDelete("/{id:int}", async (int id, ISWOTAnalysisStrengthWeaknessSettingsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_sWOTAnalysisStrengthWeakness, cancellationToken);

                return result ? Results.Ok(new { message = "SWOT deleted successfully." })
                              : Results.NotFound(new { message = "SWOT not found." });
            })
            .WithTags(_sWOTAnalysisStrengthWeakness);
        }
    }
}
