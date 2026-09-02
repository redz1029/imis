using Base.Auths.Permissions;
using Carter;
using IMIS.Application.SWOTAnalysisModule;
using IMIS.Infrastructure.Reports;
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
                  
            app.MapGet("/{id}", async (int id, ISWOTAnalysisService service, CancellationToken cancellationToken) =>
            {
                var swotAnalysisDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return swotAnalysisDto != null ? Results.Ok(swotAnalysisDto) : Results.NotFound();
            })
            .WithTags(_swotAnalysisTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_swotAnalysisTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _swotAnalysisPermission.View));
            
            app.MapGet("report-pdf/{id}", async (int id, ISWOTAnalysisService service, HttpResponse response, CancellationToken cancellationToken) =>
            {
                var operationReviewProtocolReport = await service.ReportGetByIdAsync(id, cancellationToken);

                if (operationReviewProtocolReport == null)
                    return Results.NotFound();

                var file = await ReportUtil.GeneratePdfReport<ReportSWOTAnalysisDto>("SWOTAnalysisReport",
                    new List<ReportSWOTAnalysisDto>
                    {
                        operationReviewProtocolReport
                    },
                    "SWOTAnalysis", cancellationToken).ConfigureAwait(false);

                // FORCE INLINE PDF VIEW IN BROWSER
                var fileName = $"SWOTAnalysisReport_{DateTime.Now:yyyyMMddHHmmss}.pdf";
                response.Headers.ContentDisposition = $"inline; filename={fileName}";
                return Results.File(file, "application/pdf");

                //return Results.File(file, "application/pdf", $"SWOTAnalysisReport_{DateTime.Now:yyyyMMddHHmmss}.pdf");

                //var result = await service.ReportGetByIdAsync(id, pgsId, month, year, cancellationToken).ConfigureAwait(false);
                //return result != null ? Results.Ok(result) : Results.NotFound();

                //var result = await service.ReportGetByIdAsync(id, cancellationToken);

                //if (result == null)
                //    return Results.NotFound();
                //return Results.Ok(result);
            })
            .WithTags(_swotAnalysisTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_swotAnalysisTag), true);

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
            
            app.MapGet("/filter/year", async (int? year, ISWOTAnalysisService service, CancellationToken cancellationToken) =>
            {
                int swotAnalysisDtoNoOfResults = 10;

                int finalYear = (year.HasValue && year.Value > 0) ? year.Value : DateTime.Now.Year;

                var swotAnalysisDto = await service.FilterByYearAsync(finalYear, swotAnalysisDtoNoOfResults, cancellationToken);

                return swotAnalysisDto != null && swotAnalysisDto.Any() ? Results.Ok(swotAnalysisDto) : Results.NoContent();
            })            
            .WithTags(_swotAnalysisTag).CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_swotAnalysisTag), true);
          
            app.MapGet("/page", async (int page, int pageSize, string userId, string roleId, int? officeId, ISWOTAnalysisService service, CancellationToken cancellationToken) =>
            {
                var paginatedswotAnalysisDto = await service.GetPaginatedByUserIdAsync(userId, roleId, officeId, page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedswotAnalysisDto != null ? Results.Ok(paginatedswotAnalysisDto) : Results.NotFound();
            })
            .WithTags(_swotAnalysisTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_swotAnalysisTag), true)
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
