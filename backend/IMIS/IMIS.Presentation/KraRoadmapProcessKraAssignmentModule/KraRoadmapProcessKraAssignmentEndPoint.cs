using Carter;
using IMIS.Application.KraRoadmapProcessKraAssignmentModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.KraRoadmapProcessKraAssignmentModule
{
    public class KraRoadmapProcessKraAssignmentEndPoint : CarterModule
    {
        private const string _kraRoadMapCore = "Kra Roadmap Process Kra Assignment";
        public KraRoadmapProcessKraAssignmentEndPoint() : base("/KraRoadmapProcessKraAssignment")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] KraRoadmapProcessKraAssignmentDto dto, IKraRoadmapProcessKraAssignmentService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_kraRoadMapCore, cancellationToken);
                return Results.Ok(dto);
            })
           .WithTags(_kraRoadMapCore);
        }
    }
}
