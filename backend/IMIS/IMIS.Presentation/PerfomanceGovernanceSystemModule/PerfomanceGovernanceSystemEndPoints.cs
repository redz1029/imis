using Carter;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsModule;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsModuleAPI
{
    public class PerfomanceGovernanceSystemEndPoints : CarterModule
    {
        private const string _pgsTag = "Performance Governance System";

        public PerfomanceGovernanceSystemEndPoints() : base("/pgs")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            
            app.MapPost("/", async ([FromBody] PerfomanceGovernanceSystemDto performanceGovernanceSystemDto, IPerfomanceGovernanceSystemService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var createdPerformanceGovernanceSystem = await service.SaveOrUpdateAsync(performanceGovernanceSystemDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Created($"/performanceGovernanceSystem/{createdPerformanceGovernanceSystem.Id}", createdPerformanceGovernanceSystem);

            })
            .WithTags(_pgsTag);
            //.RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager));
            app.MapGet("/", async (IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var performanceGovernanceSystem = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(performanceGovernanceSystem);
            })
           .WithTags(_pgsTag)
           //.RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager))
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
            app.MapGet("/{id}", async (int id, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var performanceGovernanceSystem = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return performanceGovernanceSystem != null ? Results.Ok(performanceGovernanceSystem) : Results.NotFound();
            })
            .WithTags(_pgsTag)
            //.RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
            app.MapGet("userId/{id}", async (string userId, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var performanceGovernanceSystem = await service.GetByUserIdAsync(userId, cancellationToken).ConfigureAwait(false);
                return performanceGovernanceSystem != null ? Results.Ok(performanceGovernanceSystem) : Results.NotFound();
            })
           .WithTags(_pgsTag)
           //.RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager))
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
            app.MapPut("/{id}", async (int id, [FromBody] PerfomanceGovernanceSystemDto performanceGovernanceSystemDto, IPerfomanceGovernanceSystemService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existingPerformanceGovernanceSystem = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingPerformanceGovernanceSystem == null)
                {
                    return Results.NotFound($"Performance Governance System with ID {id} not found.");
                }

                var updatedexistingPgsAuditDetails = await service.SaveOrUpdateAsync(performanceGovernanceSystemDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Ok(updatedexistingPgsAuditDetails);
            })
           .WithTags(_pgsTag);
            //.RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager));
            app.MapGet("/list-report/pdf/{id}", async (int id, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var performanceGovernanceSystem = await service.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                var file = await ReportUtil.GeneratePdfReport<ReportPerfomanceGovernanceSystemDto>(
                    "PerfomanceGovernanceSystem",
                    new List<ReportPerfomanceGovernanceSystemDto> { performanceGovernanceSystem! },
                    "PerfomanceGovernanceSystem",
                    cancellationToken
                ).ConfigureAwait(false);
                return Results.File(file, "application/pdf", $"ReportPerfomanceGovernanceSystem_{DateTime.Now:yyyyMMddHHmmss}.pdf");

                //var performanceGovernanceSystem = await service.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                //return performanceGovernanceSystem != null ? Results.Ok(performanceGovernanceSystem) : Results.NotFound();
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

            app.MapGet("/list-report/{id}", async (int id, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                // Get single report data by id
                var performanceGovernanceSystem = await service.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);

                //Wrap in enumerable for the report -or empty if null
                var data = performanceGovernanceSystem != null
                    ? new[] { performanceGovernanceSystem }
                    : Enumerable.Empty<ReportPerfomanceGovernanceSystemDto>();

                // Generate the web report (dataSourceName should match your report's datasource name)
                var webReport = await ReportUtil.GenerateWebReport<ReportPerfomanceGovernanceSystemDto>(
                    "PerfomanceGovernanceSystem",
                    data,
                    "PerfomanceGovernanceSystem"
                ).ConfigureAwait(false);

                // Return HTML content of the report
                return Results.Content(webReport.ToString(), "text/html", statusCode: 200);
               
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

            app.MapGet("/page", async (int page, int pageSize, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var paginatedPerformanceGovernanceSystem = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedPerformanceGovernanceSystem;
            })
            .WithTags(_pgsTag)
            //.RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
            app.MapGet("/pgsPeriod/{id}", async (IPerfomanceGovernanceSystemService service, long? pgsPeriodId, CancellationToken cancellationToken) =>
            {
                var performanceGovernanceSystem = await service.GetAllAsyncFilterByPgsPeriod(pgsPeriodId, cancellationToken).ConfigureAwait(false);

                if (performanceGovernanceSystem == null || !performanceGovernanceSystem.Any())
                {
                    return Results.NotFound("No records found for the given PgsPeriodId.");
                }
                return Results.Ok(performanceGovernanceSystem);
            })
            .WithTags(_pgsTag)
            //.RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

            app.MapGet("/page/pgsPeriod/{id}", async (long? pgsPeriodId, int page, int pageSize, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var paginatedPerformanceGovernanceSystem = await service.GetPaginatedPgsPeriodIdAsync(pgsPeriodId, page, pageSize, cancellationToken).ConfigureAwait(false);
               
                if (paginatedPerformanceGovernanceSystem == null || !paginatedPerformanceGovernanceSystem.Items.Any())
                {
                    return Results.NotFound("No records found for the given PgsPeriodId.");
                }
                return Results.Ok(paginatedPerformanceGovernanceSystem);
            })
            .WithTags(_pgsTag)
            //.RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
        }
    }
}
