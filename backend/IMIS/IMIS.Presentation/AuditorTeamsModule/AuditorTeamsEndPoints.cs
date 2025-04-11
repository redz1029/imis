using Carter;
using IMIS.Application.AuditorTeamsModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditorTeamsModule
{
    public class AuditorTeamsEndPoints : CarterModule
    {

        private const string _AuditorTeamTag = "AuditorTeam";
        public AuditorTeamsEndPoints() : base("/auditorTeam")        
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] AuditorTeamsDto auditorTeamsDto, IAuditorTeamsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {               
                var createdAuditorTeamsDto = await service.SaveOrUpdateAsync(auditorTeamsDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditorTeamTag, cancellationToken);               
                return Results.Created($"/auditorTeams/{createdAuditorTeamsDto}", createdAuditorTeamsDto);
            })
           .WithTags(_AuditorTeamTag);

            app.MapGet("/", async (IAuditorTeamsService service, CancellationToken cancellationToken) =>
            {
                var keyResultAreaDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(keyResultAreaDto);
            })
         .WithTags(_AuditorTeamTag)
         .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditorTeamTag), true);

        }
    }
}
