using Carter;
using IMIS.Application.AuditorTeamsModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.AuditorTeamsModule
{
    public class AuditorTeamsEndPoints : CarterModule
    {

        private const string _AuditorTeamTag = "Create AuditorTeam";
        public AuditorTeamsEndPoints() : base("/AuditorTeam")        
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] AuditorTeamsDto auditorTeamsDto, IAuditorTeamsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {               
                var createdAuditorTeamsDto = await service.SaveOrUpdateAsync(auditorTeamsDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditorTeamTag, cancellationToken);               
                return Results.Created($"/AuditorTeams/{createdAuditorTeamsDto}", createdAuditorTeamsDto);
            })
           .WithTags(_AuditorTeamTag);

        }
    }
}
