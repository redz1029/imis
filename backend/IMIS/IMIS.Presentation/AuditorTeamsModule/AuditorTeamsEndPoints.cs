using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditorTeamsModule;
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
                await service.SaveOrUpdateAsync(auditorTeamsDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditorTeamTag, cancellationToken);
                return Results.Ok(auditorTeamsDto);
            })
           .WithTags(_AuditorTeamTag)           
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorTeamPermission.Add));

            app.MapGet("/", async (IAuditorTeamsService service, CancellationToken cancellationToken) =>
            {
                var AuditorTeamDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(AuditorTeamDto);
            })
            .WithTags(_AuditorTeamTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditorTeamTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorTeamPermission.View));

            app.MapGet("/teamid/{id:long}", async (long id, IAuditorTeamsService service, CancellationToken cancellationToken) =>
            {
                var team = await service.GetByTeamIdAsync(id, cancellationToken).ConfigureAwait(false);

                if (team == null)
                {
                    return Results.NotFound(new { message = $"No records found for TeamId {id}." });
                }

                return Results.Ok(team);
            })
            .WithTags(_AuditorTeamTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditorTeamTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorTeamPermission.View));

            app.MapPut("/teamid", async ([FromBody] AuditorTeamsDto auditorTeamsDto, IAuditorTeamsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {                        
                await service.SaveOrUpdateAsync(auditorTeamsDto, cancellationToken).ConfigureAwait(false);

                await cache.EvictByTagAsync(_AuditorTeamTag, cancellationToken);
                    
                return Results.Ok(auditorTeamsDto);                              
            })
            .WithTags(_AuditorTeamTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorTeamPermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IAuditorTeamsService service, CancellationToken cancellationToken) =>
            {
                var auditorTeamsDto = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(auditorTeamsDto);
            })
            .WithTags(_AuditorTeamTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditorTeamTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorTeamPermission.View));

            app.MapDelete("/{id:int}", async (int id, IAuditorTeamsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_AuditorTeamTag, cancellationToken);

                return result ? Results.Ok(new { message = "Auditor Team deleted successfully." })
                              : Results.NotFound(new { message = "Auditor Team not found." });
            })
            .WithTags(_AuditorTeamTag)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _auditorTeamPermission.Edit));
        }
    }
}
