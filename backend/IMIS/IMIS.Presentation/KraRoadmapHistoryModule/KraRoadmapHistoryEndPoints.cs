using Carter;
using IMIS.Application.KraRoadmapHistoryModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.KraRoadmapHistoryModule
{
    public class KraRoadmapHistoryEndPoints : CarterModule
    {
        private const string _kraRoadmapHistory = "KraRoadmapHistory";
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapGet("/roadmapidlist", async (long? roadmapid, IKraRoadmapHistoryService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAll(roadmapid, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_kraRoadmapHistory)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_kraRoadmapHistory));
        }
    }
}
