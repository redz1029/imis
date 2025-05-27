using Base.Auths.Permissions;
using Carter;
using IMIS.Application.TeamModule;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.TeamModule
{
    public class TeamEndPoints : CarterModule
    {
        private const string _teamTag = "Team";         
        public readonly TeamPermission _teamPermission = new();
        public TeamEndPoints() : base("/team")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {         
            app.MapPost("/", async ([FromBody] TeamDto teamDto, ITeamService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {               
                var createdTeam = await service.SaveOrUpdateAsync(teamDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_teamTag, cancellationToken);
                return Results.Created($"/team/{createdTeam.Id}", createdTeam);
            })
            .WithTags(_teamTag)          
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim,_teamPermission.Add, _teamPermission.Edit));

            app.MapGet("/", async (ITeamService service, CancellationToken cancellationToken) =>
            {
                var team = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(team);
            })
           .WithTags(_teamTag)           
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_teamTag), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _teamPermission.View));

            app.MapGet("/filter/{name}", async (string name, ITeamService service, CancellationToken cancellationToken) =>
            {
                int teamNoOfResults = 10;
                var team = await service.FilterByName(name, teamNoOfResults, cancellationToken).ConfigureAwait(false);
                return team != null ? Results.Ok(team) : Results.NoContent();
            })
          .WithTags(_teamTag)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_teamTag), true);

            app.MapGet("/{id}", async (int id, ITeamService service, CancellationToken cancellationToken) =>
            {
                var team = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return team != null ? Results.Ok(team) : Results.NotFound();
            })
          .WithTags(_teamTag)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_teamTag), true);
            app.MapPut("/{id}", async (int id, [FromBody] TeamDto teamDto, ITeamService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {               
                var existingTeam = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingTeam == null)
                {
                    return Results.NotFound($"Team with ID {id} not found.");
                }

                var updatedTeam = await service.SaveOrUpdateAsync(teamDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_teamTag, cancellationToken);
                return Results.Ok(updatedTeam);
            })
           .WithTags(_teamTag);
            app.MapGet("/page", async (int page, int pageSize, ITeamService service, CancellationToken cancellationToken) =>
            {
                var paginatedTeam = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedTeam);
            })
           .WithTags(_teamTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_teamTag), true);
        }
    }      
}
