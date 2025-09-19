using Carter;
using IMIS.Application.PgsSummaryNarrativeModule;
using IMIS.Application.PgsSummaryNarrativeModules;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsSummaryNarrativeModule
{
    public class PgsSummaryNarrativeEndPoints : CarterModule
    {

        private const string _pgsSummaryNarrativeTag = "PGSSummaryNarrativeTag";       
        public PgsSummaryNarrativeEndPoints() : base("/pgsSummaryNarrative")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PGSSummaryNarrativeDto userOfficeDto, IPGSSummaryNarrativeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(userOfficeDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsSummaryNarrativeTag, cancellationToken);
                return Results.Ok(userOfficeDto);
            })
           .WithTags(_pgsSummaryNarrativeTag);           
            app.MapGet("/", async (IPGSSummaryNarrativeService service, CancellationToken cancellationToken) =>
            {
                var period = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(period);
            })
           .WithTags(_pgsSummaryNarrativeTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsSummaryNarrativeTag), true);
            app.MapPut("/{id}", async (int id, [FromBody] PGSSummaryNarrativeDto pgsSummaryNarrativeDto, IPGSSummaryNarrativeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {               
                await service.SaveOrUpdateAsync(pgsSummaryNarrativeDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsSummaryNarrativeTag, cancellationToken);
                return Results.Ok(pgsSummaryNarrativeDto);
            })
            .WithTags(_pgsSummaryNarrativeTag);        
            app.MapGet("/{pgsPeriodId:int}", async (int pgsPeriodId, IPGSSummaryNarrativeService service, CancellationToken cancellationToken) =>
            {
                var narrative = await service.GetByPeriodIdAsync(pgsPeriodId, cancellationToken).ConfigureAwait(false);
                if (narrative == null) return Results.NotFound();
                return Results.Ok(narrative);
            })
           .WithTags(_pgsSummaryNarrativeTag);

            app.MapGet("/list-report/pdf", async ([AsParameters] PgsDeliverableSummaryNarrativeFilter filter, IPGSSummaryNarrativeService service, HttpResponse response, CancellationToken cancellationToken) =>
            {
                
                var reportPGSSummaryNarrativeDto = await service.ReportGetByFilterAsync(filter, cancellationToken)
                    .ConfigureAwait(false);

                var file = await ReportUtil.GeneratePdfReport<ReportPGSSummaryNarrativeDto>(
                    "SummaryNarrativeReport",
                    reportPGSSummaryNarrativeDto,
                    "SummaryNarrativeReport",
                    cancellationToken
                ).ConfigureAwait(false);

                return Results.File(file, "application/pdf", $"ReportPgsSummaryNarrative_{DateTime.Now:yyyyMMddHHmmss}.pdf");

            })
            .WithTags(_pgsSummaryNarrativeTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsSummaryNarrativeTag), true);
         
        }
    }
}
