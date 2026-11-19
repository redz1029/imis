using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PolicyAndProcedureSectionNumberingModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PolicyAndProcedureSectionNumberingModule
{
    public class PolicyAndProcedureSectionNumberingEndPoints : CarterModule
    {
        private const string _policyAndProcedureSectionNumbering = "Policy And Procedure Section Numbering";
        public readonly PolicyAndProcedureSectionNumberingPermission _policyAndProcedureSectionNumberingPermission = new();
        public PolicyAndProcedureSectionNumberingEndPoints() : base("/policyAndProcedureSectionNumbering")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PolicyAndProcedureSectionNumberingDto policyAndProcedureSectionNumberingDto, IPolicyAndProcedureSectionNumberingService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(policyAndProcedureSectionNumberingDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_policyAndProcedureSectionNumbering, cancellationToken);
                return Results.Ok(policyAndProcedureSectionNumberingDto);
            })
            .WithTags(_policyAndProcedureSectionNumbering)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedureSectionNumberingPermission.Add));

            app.MapGet("/{id}", async (int id, IPolicyAndProcedureSectionNumberingService service, CancellationToken cancellationToken) =>
            {
                var policyAndProcedureSectionNumberingDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return policyAndProcedureSectionNumberingDto != null ? Results.Ok(policyAndProcedureSectionNumberingDto) : Results.NotFound();
            })
             .WithTags(_policyAndProcedureSectionNumbering)
             .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureSectionNumbering), true)
             .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedureSectionNumberingPermission.View));

            app.MapGet("/", async (IPolicyAndProcedureSectionNumberingService service, CancellationToken cancellationToken) =>
            {
                var period = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(period);
            })
            .WithTags(_policyAndProcedureSectionNumbering)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureSectionNumbering), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedureSectionNumberingPermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] PolicyAndProcedureSectionNumberingDto policyAndProcedureSectionNumberingDto, IPolicyAndProcedureSectionNumberingService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {                               
                policyAndProcedureSectionNumberingDto.Id = id;
                await service.SaveOrUpdateAsync(policyAndProcedureSectionNumberingDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_policyAndProcedureSectionNumbering, cancellationToken);
                return Results.Ok(policyAndProcedureSectionNumberingDto);              
            })
           .WithTags(_policyAndProcedureSectionNumbering)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedureSectionNumberingPermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IPolicyAndProcedureSectionNumberingService service, CancellationToken cancellationToken) =>
            {
                var paginatedDto = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedDto);
            })
            .WithTags(_policyAndProcedureSectionNumbering)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureSectionNumbering), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedureSectionNumberingPermission.View));

            app.MapDelete("/{id:int}", async (int id, IPolicyAndProcedureSectionNumberingService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_policyAndProcedureSectionNumbering, cancellationToken);

                return result ? Results.Ok(new { message = "PAP` deleted successfully." })
                              : Results.NotFound(new { message = "Period not found." });
            })
         .WithTags(_policyAndProcedureSectionNumbering)
         .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedureSectionNumberingPermission.Delete));
        }
    }
}
