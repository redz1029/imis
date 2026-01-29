using Base.Auths.Permissions;
using Carter;
using IMIS.Application.KraRoadMapModule;
using IMIS.Infrastructure.Reports;
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

            app.MapGet("/filter", async ([FromQuery] int kraId, [FromQuery] int year, [FromQuery] string kraDescription, [FromQuery] bool isDirect,
            IKraRoadMapService service, CancellationToken cancellationToken) =>
            {
                if (string.IsNullOrWhiteSpace(kraDescription))                    
                    return Results.BadRequest("kraDescription is required");

                var result = await service.GetFilteredDeliverablesAsync(kraId, year, kraDescription, isDirect, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_kraRoadMap)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_kraRoadMap), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPermission.View));

            app.MapGet("/getAllkraDescriptions", async ([FromQuery] int kraId, IKraRoadMapService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllKraDescriptionsByKraIdAsync(kraId, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_kraRoadMap)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_kraRoadMap), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPermission.View));

            app.MapGet("/list-report/pdf/{id}", async (int id, IKraRoadMapService service, HttpResponse response, CancellationToken cancellationToken) =>
            {
                var reportKraRoadMapDto = await service.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);

                var file = await ReportUtil.GeneratePdfReport<ReportKraRoadMapDto>(
                    "RoadmapReport",
                    new List<ReportKraRoadMapDto> { reportKraRoadMapDto! },
                    "RoadmapReport",
                    cancellationToken
                ).ConfigureAwait(false);

                //Force inline rendering in browser with dynamic timestamp filename
                var fileName = $"ReportPerfomanceGovernanceSystem{DateTime.Now:yyyyMMddHHmmss}.pdf";
                response.Headers["Content-Disposition"] = $"inline; filename={fileName}";
                return Results.File(file, "application/pdf");

                //return Results.File(file, "application/pdf", $"ReportKraRoadMapDto_{DateTime.Now:yyyyMMddHHmmss}.pdf");

                //var kraRoadMapDto = await service.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                //return kraRoadMapDto != null ? Results.Ok(kraRoadMapDto) : Results.NotFound();
            })
           .WithTags(_kraRoadMap)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_kraRoadMap), true);

            ////// Get All roadmap Role        
            app.MapGet("/roleid/{roleId}", async (string roleId, IKraRoadMapService service, CancellationToken cancellationToken) =>
            {
                 var kraRoadMapDto = await service.GetAllRoadmapForUserAsync(roleId, cancellationToken).ConfigureAwait(false);
                     return Results.Ok(kraRoadMapDto);
            })
            .WithTags(_kraRoadMap)
            .RequireAuthorization(e =>  e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapPermission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_kraRoadMap), true);
        }
    }
}
