using Carter;
using IMIS.Application.KraRoadmapCoreSupportProcessModule;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.KraRoadmapCoreSupportProcessModule
{
    public class KraRoadmapCoreSupportProcessEndPoint : CarterModule
    {
        private const string _kraRoadMapCore = "Kra Roadmap Core And Support";     
        public KraRoadmapCoreSupportProcessEndPoint() : base("/KraRoadmapCoreAndSupport")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] KraRoadmapCoreSupportProcessDto dto, IKraRoadmapCoreSupportProcessService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_kraRoadMapCore, cancellationToken);
                return Results.Ok(dto);
            })
           .WithTags(_kraRoadMapCore);
         
            app.MapGet("/list-report/pdf", async (int kraRoadMapPeriodId, IKraRoadmapCoreSupportProcessService service, HttpResponse response, CancellationToken cancellationToken) =>
            {
                var groupedData = await service.ReportGetByIdAsync(kraRoadMapPeriodId, cancellationToken)
                    .ConfigureAwait(false);

                var file = await ReportUtil.GeneratePdfReport<KraProcessGroupedDto>("KraRoadmapAccomplishmentReport", groupedData!, "ReportKraDto",  cancellationToken).ConfigureAwait(false);

                //Force inline rendering in browser with dynamic timestamp filename
                var fileName = $"ReportPerfomanceGovernanceSystem{DateTime.Now:yyyyMMddHHmmss}.pdf";
                response.Headers["Content-Disposition"] = $"inline; filename={fileName}";
                return Results.File(file, "application/pdf");

                //return Results.File(file, "application/pdf", $"ReportKraRoadMapDto_{DateTime.Now:yyyyMMddHHmmss}.pdf");               
            })
            .WithTags(_kraRoadMapCore)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_kraRoadMapCore), true);
        }
    }
}
