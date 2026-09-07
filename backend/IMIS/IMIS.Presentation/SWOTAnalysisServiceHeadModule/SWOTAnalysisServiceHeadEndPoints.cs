using Base.Auths.Permissions;
using Carter;
using IMIS.Application.SWOTAnalysisServiceHeadModule;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.SWOTAnalysisServiceHeadModule
{
    public class SWOTAnalysisServiceHeadEndPoints : CarterModule
    {
        private const string _swotAnalysisServiceHeadTag = "SWOT Analysis Service Head";
        public readonly SWOTAnalysisServiceHeadPermission _sWOTAnalysisServiceHeadPermission = new();
        public SWOTAnalysisServiceHeadEndPoints() : base("/sWOTAnalysisServiceHead")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] SWOTAnalysisServiceHeadDto sWOTAnalysisServiceHeadDto, ISWOTAnalysisServiceHeadService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(sWOTAnalysisServiceHeadDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_swotAnalysisServiceHeadTag, cancellationToken);
                return Results.Ok(sWOTAnalysisServiceHeadDto);
            })
            .WithTags(_swotAnalysisServiceHeadTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _sWOTAnalysisServiceHeadPermission.Add));

            app.MapGet("/{id}", async (int id, ISWOTAnalysisServiceHeadService service, CancellationToken cancellationToken) =>
            {
                var sWOTAnalysisServiceHeadDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return sWOTAnalysisServiceHeadDto != null ? Results.Ok(sWOTAnalysisServiceHeadDto) : Results.NotFound();
            })
           .WithTags(_swotAnalysisServiceHeadTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_swotAnalysisServiceHeadTag), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _sWOTAnalysisServiceHeadPermission.View));

            app.MapGet("report-pdf/{id}", async (int id, ISWOTAnalysisServiceHeadService service, HttpResponse response, CancellationToken cancellationToken) =>
            {
                var sWOTAnalysisServiceHeadDto = await service.ReportGetByIdAsync(id, cancellationToken);

                if (sWOTAnalysisServiceHeadDto == null)
                    return Results.NotFound();

                var file = await ReportUtil.GeneratePdfReport<ReportSWOTAnalysisServiceHeadDto>("SWOTAnalysisServiceHeadReport",
                    new List<ReportSWOTAnalysisServiceHeadDto>
                    {
                        sWOTAnalysisServiceHeadDto
                    },
                    "SWOTAnalysisServiceHead", cancellationToken).ConfigureAwait(false);

                //FORCE INLINE PDF VIEW IN BROWSER
                var fileName = $"SWOTAnalysisServiceHeadReport_{DateTime.Now:yyyyMMddHHmmss}.pdf";
                response.Headers.ContentDisposition = $"inline; filename={fileName}";
                return Results.File(file, "application/pdf");

                //return Results.File(file, "application/pdf", $"SWOTAnalysisServiceHeadReport{DateTime.Now:yyyyMMddHHmmss}.pdf");

                //var result = await service.ReportGetByIdAsync(id, pgsId, month, year, cancellationToken).ConfigureAwait(false);
                //return result != null ? Results.Ok(result) : Results.NotFound();

                //var result = await service.ReportGetByIdAsync(id, cancellationToken);

                //if (result == null)
                //    return Results.NotFound();
                //return Results.Ok(result);
            })
            .WithTags(_swotAnalysisServiceHeadTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_swotAnalysisServiceHeadTag), true);

            app.MapPut("/{id}", async (int id, [FromBody] SWOTAnalysisServiceHeadDto sWOTAnalysisServiceHeadDto, ISWOTAnalysisServiceHeadService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existingsWOTAnalysisServiceHeadDto = await service.GetByIdAsync(id, cancellationToken);
                if (existingsWOTAnalysisServiceHeadDto == null)
                    return Results.NotFound($"SWOT Analysis Service Head with ID {id} not found.");

                sWOTAnalysisServiceHeadDto.Id = id;
                await service.SaveOrUpdateAsync(sWOTAnalysisServiceHeadDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_swotAnalysisServiceHeadTag, cancellationToken);
                return Results.Ok(sWOTAnalysisServiceHeadDto);

            })
           .WithTags(_swotAnalysisServiceHeadTag)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _sWOTAnalysisServiceHeadPermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, string userId, string roleId, int? officeId, ISWOTAnalysisServiceHeadService service, CancellationToken cancellationToken) =>
            {
                var paginatedswotAnalysisDto = await service.GetPaginatedByUserIdAsync(userId, roleId, officeId, page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedswotAnalysisDto != null ? Results.Ok(paginatedswotAnalysisDto) : Results.NotFound();
            })
           .WithTags(_swotAnalysisServiceHeadTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_swotAnalysisServiceHeadTag), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _sWOTAnalysisServiceHeadPermission.View));

            app.MapDelete("/{id:int}", async (int id, ISWOTAnalysisServiceHeadService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_swotAnalysisServiceHeadTag, cancellationToken);

                return result ? Results.Ok(new { message = "SWOT Analysis deleted successfully." })
                              : Results.NotFound(new { message = "SWOT Analysis not found." });
            })
            .WithTags(_swotAnalysisServiceHeadTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _sWOTAnalysisServiceHeadPermission.Delete));

        }
    }
}
