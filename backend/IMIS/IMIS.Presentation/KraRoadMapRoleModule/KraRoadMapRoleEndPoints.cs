using Carter;
using IMIS.Application.KraRoadMapRoleAssignmentModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.KraRoadMapRoleModule
{
    public class KraRoadMapRoleEndPoints : CarterModule
    {
        private const string _kraRoadmapRole = "KRA Roadmap Role";      
        public KraRoadMapRoleEndPoints() : base("/KRARoadmapRole")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] KraRoadMapRoleDto kraRoadMapRoleDto, IKraRoadMapRoleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(kraRoadMapRoleDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_kraRoadmapRole, cancellationToken);
                return Results.Ok(kraRoadMapRoleDto);
            })
           .WithTags(_kraRoadmapRole);          
            
            app.MapGet("/roleid", async (IKraRoadMapRoleService service, CancellationToken cancellationToken) =>
            {
                var kraRoadMapRoleDto = await service.GetAllRoadmapForUserAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(kraRoadMapRoleDto);
            })
            .WithTags(_kraRoadmapRole)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_kraRoadmapRole), true);
        }
    }
}
