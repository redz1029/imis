using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PolicyAndProcedureOfficeDocumentDistributionModule
{
    public class PolicyAndProcedureOfficeDocumentDistributionEndPoints : CarterModule
    {
        private const string _policyAndProcedureOfficeDocumentDistribution = "Policy And Procedure Office Document Distribution";
        public readonly PolicyAndProcedureOfficeDocumentDistributionPermission _policyAndProcedureOfficeDocumentDistributionPermission = new();
        public PolicyAndProcedureOfficeDocumentDistributionEndPoints() : base("/PolicyAndProcedureOfficeDocumentDistribution") { }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/{id:long}", async (long id, IPolicyAndProcedureOfficeDocumentDistributionService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdAsync(id, ct).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_policyAndProcedureOfficeDocumentDistribution)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureOfficeDocumentDistribution), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedureOfficeDocumentDistributionPermission.View));

            app.MapPost("/", async (PolicyAndProcedureOfficeDocumentDistributionDto dto, IPolicyAndProcedureOfficeDocumentDistributionService service, CancellationToken ct) =>
            {
                try
                {
                    var result = await service.SaveOrUpdateAsync(dto, ct).ConfigureAwait(false);
                    return Results.Ok(result);
                }
                catch (InvalidOperationException ex)
                {
                    return Results.NotFound(ex.Message);
                }
            })
          .WithTags(_policyAndProcedureOfficeDocumentDistribution)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedureOfficeDocumentDistributionPermission.Add));
            
        }
    }
}
