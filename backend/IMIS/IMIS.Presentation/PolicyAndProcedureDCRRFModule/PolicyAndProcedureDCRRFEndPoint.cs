using Carter;
using IMIS.Application.PolicyAndProcedureDCRRFModule;
using IMIS.Application.PolicyAndProcedureHistoryLogModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PolicyAndProcedureDCRRFModule
{
    public class PolicyAndProcedureDCRRFEndPoint : CarterModule
    {
        private const string _policyAndProcedureDCRRF = "Policy And Procedure DCRRF";
        public PolicyAndProcedureDCRRFEndPoint() : base("/PolicyAndProcedureDCRRF") { }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/{id:long}", async (long id, IPolicyAndProcedureDCRRFService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdAsync(id, ct).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.NotFound();
            })
          .WithTags(_policyAndProcedureDCRRF)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureDCRRF), true);

            app.MapPut("/{id}", async (int id, [FromBody] PolicyAndProcedureDCRRFDto policyAndProcedureDCRRFDto, IPolicyAndProcedureDCRRFService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existingpolicyAndProcedureDCRRFDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingpolicyAndProcedureDCRRFDto == null)
                {
                    return Results.NotFound($"DCRRF with ID {id} not found.");
                }
                await service.SaveOrUpdateAsync(policyAndProcedureDCRRFDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_policyAndProcedureDCRRF, cancellationToken);
                return Results.Ok(policyAndProcedureDCRRFDto);
            })
           .WithTags(_policyAndProcedureDCRRF);

            app.MapGet("history/{id:long}", async (long id, IPolicyAndProcedureHistoryLogService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdDCRRFAsync(id, ct).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.NotFound();
            })
           .WithTags(_policyAndProcedureDCRRF)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureDCRRF), true);
        }

    }
}
