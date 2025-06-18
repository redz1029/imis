using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditorTeamsModule;
using IMIS.Application.AuditScheduleModule;
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
        public readonly AuditorTeamPermission _auditorTeamPermission = new();
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
           .WithTags(_AuditorTeamTag)
           .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim, _auditorTeamPermission.Add));

            app.MapGet("/", async (IAuditorTeamsService service, CancellationToken cancellationToken) =>
            {
                var AuditorTeamDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(AuditorTeamDto);
            })
            .WithTags(_AuditorTeamTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditorTeamTag), true)
            .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim, _auditorTeamPermission.View));

            app.MapGet("/teamid/{id}", async (IAuditorTeamsService service, long? teamId, CancellationToken cancellationToken) =>
            {
                var team = await service.GetAllAsyncFilterByTeamId(teamId, cancellationToken).ConfigureAwait(false);

                if (team == null || !team.Any())
                {
                    return Results.NotFound("No records found for the given teamId.");
                }
                return Results.Ok(team);
            })
           .WithTags(_AuditorTeamTag)        
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditorTeamTag), true)
           .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim, _auditorTeamPermission.View));
        }
    }
}
