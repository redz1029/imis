
using Carter;
using IMIS.Application.PgsDeliverableScoreHistoryModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.TeamModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.PgsDeliverableScoreHistoryModule
{
    public class PgsDeliverableScoreHistoryEndPoints : CarterModule
    {
        private const string _pgsDeliverableScoreHistory = "PgsDeliverable Score History";
    
        public PgsDeliverableScoreHistoryEndPoints() : base("/pgsDeliverableScoreHistory")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PgsDeliverableScoreHistoryDto pgsDeliverableScoreHistoryDto, IPgsDeliverableScoreHistoryService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var createdTeam = await service.SaveOrUpdateAsync(pgsDeliverableScoreHistoryDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsDeliverableScoreHistory, cancellationToken);
                return Results.Created($"/pgsDeliverableScoreHistory/{createdTeam}", createdTeam);
            })
           .WithTags(_pgsDeliverableScoreHistory);         
        }
    }
}
