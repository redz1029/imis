using Base.Auths.Permissions;
using Carter;
using IMIS.Application.OperationReviewProtocolModule;
using IMIS.Application.PerformanceValidationToolModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsSignatoryModule;
using IMIS.Domain;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PerformanceValidationToolModule
{
    public class PerformanceValidationToolEndPoint : CarterModule
    {
        private const string _performanceValidationTool = "Performance Validation Tool";
        public readonly PerformanceValidationToolPermission _performanceValidationToolPermission = new();
        public PerformanceValidationToolEndPoint() : base("/performanceValidationTool")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PerformanceValidationToolDto dto, IPerformanceValidationToolService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_performanceValidationTool,  cancellationToken);
                return Results.Ok(dto);
            })
           .WithTags(_performanceValidationTool)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.Draft));

            app.MapGet("/{id:long}", async (long id, IPerformanceValidationToolService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);
                return result is null ? Results.NotFound() : Results.Ok(result);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.View));
           
            app.MapGet("/pdf-report/{id:long}", async (HttpResponse response, long id, IPerformanceValidationToolService service, CancellationToken cancellationToken) =>
            {
                var performanceValidationToolreport = await service.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);

                if (performanceValidationToolreport == null)
                    return Results.NotFound();

                var file = await ReportUtil.GeneratePdfReport<ReportPerformanceValidationToolDto>("PerformanceValidationToolReport",
                    new List<ReportPerformanceValidationToolDto>
                    {
                        performanceValidationToolreport
                    },
                    "PerformanceValidationTool", cancellationToken).ConfigureAwait(false);

                // FORCE INLINE PDF VIEW IN BROWSER
                //var fileName = $"PerformanceValidationToolReport_{DateTime.Now:yyyyMMddHHmmss}.pdf";
                //response.Headers.ContentDisposition = $"inline; filename={fileName}";
                //return Results.File(file, "application/pdf");

                return Results.File(file, "application/pdf", $"PerformanceValidationToolReport_{DateTime.Now:yyyyMMddHHmmss}.pdf");

                //var result = await service.ReportGetByIdAsync(id, pgsId, month, year, cancellationToken).ConfigureAwait(false);
                //return result != null ? Results.Ok(result) : Results.NotFound();
            })
             .WithTags(_performanceValidationTool)
             .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true);           

            app.MapGet("/", async (IPerformanceValidationToolService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.View));

            app.MapPut("/", async ([FromBody] PerformanceValidationToolDto dto, IPerformanceValidationToolService service, IOutputCacheStore cache,  CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_performanceValidationTool, cancellationToken);  
                return Results.Ok(dto);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.Edit));

            app.MapGet("/pgsAuditor/{roleId}", async (string roleId, long? officeId, long? pgsPeriodId, int page, int pageSize, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAuditorPgsDeliverableAsync(roleId, officeId, pgsPeriodId, page, pageSize, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.View));

            app.MapGet("/pgsidlist", async (long? performanceGovernanceSystemId, IPerformanceValidationToolService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllPgsIdTool(performanceGovernanceSystemId, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool))
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.View));

            app.MapGet("/pgsiddiverable/{id}", async (int id, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var performanceGovernanceSystem = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return performanceGovernanceSystem != null ? Results.Ok(performanceGovernanceSystem) : Results.NotFound();
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.View));

            app.MapGet("/PgsSignatory", async (long? pgsSignatoryId, IPgsSignatoryService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllPgsSignatoryId(pgsSignatoryId, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_performanceValidationTool)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool))
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.View));

            app.MapPut("/submit", async ([FromBody] PerformanceValidationToolDto dto, string userId, IPerformanceValidationToolService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var submitted = await service.Submit(dto, userId, cancellationToken);

                await cache.EvictByTagAsync(_performanceValidationTool, cancellationToken);

                return Results.Created($"/performanceValidationTool/{submitted.Id}", submitted);
            })
           .WithTags(_performanceValidationTool)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.Submit));

            app.MapGet("/submit/userId/{userId}", async (string userId, long performanceValidationToolId, IPerformanceValidationToolService service, CancellationToken cancellationToken) =>
            {
                var dto = await service.GetByUserIdAndPerformanceValidationToolIdAsync(userId, performanceValidationToolId, cancellationToken);

                return dto != null ? Results.Ok(dto): Results.NotFound();
            })
            .WithTags(_performanceValidationTool)    
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_performanceValidationTool), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.View));

            app.MapDelete("/{id:int}", async (int id, IPerformanceValidationToolService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_performanceValidationTool, cancellationToken);

                return result ? Results.Ok(new { message = "Successfully deleted." })
                              : Results.NotFound(new { message = "Template not found." });
            })
          .WithTags(_performanceValidationTool)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _performanceValidationToolPermission.Delete));
        }
    }
}
