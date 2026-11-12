using Carter;
using IMIS.Application.PolicyAndProcedureHistoryLogModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PolicyAndProcedureHistoryLogModule
{
    public class PolicyAndProcedureHistoryLogEndPoints : CarterModule
    {
        private const string _policyAndProcedureHistoryLog = "Policy And Procedure History Log";

        public PolicyAndProcedureHistoryLogEndPoints() : base("/PolicyAndProcedureHistoryLog") { }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/{id:long}", async (long id, IPolicyAndProcedureHistoryLogService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdAsync(id, ct).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_policyAndProcedureHistoryLog)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureHistoryLog), true);

            app.MapPost("/", async (PolicyAndProcedureHistoryLogDto dto, IPolicyAndProcedureHistoryLogService service, CancellationToken ct) =>
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
            .WithTags(_policyAndProcedureHistoryLog);
        }
    }
}