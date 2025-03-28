using Carter;
using IMIS.Application.PgsKraModule;
using IMIS.Application.TeamModule;
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

        private const string _TeamTag = "Create Team";
        public TeamEndPoints() : base("/Team")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] TeamDto TeamDto, ITeamService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (TeamDto == null)
                {
                    return Results.BadRequest("Team data is required.");
                }
                var createdTeam = await service.SaveOrUpdateAsync(TeamDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_TeamTag, cancellationToken);
                return Results.Created($"/Team/{createdTeam.Id}", createdTeam);
            })
            .WithTags(_TeamTag);

            app.MapGet("/", async (ITeamService service, CancellationToken cancellationToken) =>
            {
                var Team = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(Team);
            })
           .WithTags(_TeamTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_TeamTag), true);

            app.MapGet("/filter/{name}", async (string name, ITeamService service, CancellationToken cancellationToken) =>
            {
                int noOfResults = 10;
                var Team = await service.FilterByName(name, noOfResults, cancellationToken).ConfigureAwait(false);
                return Team != null ? Results.Ok(Team) : Results.NoContent();
            })
          .WithTags(_TeamTag)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_TeamTag), true);

            app.MapGet("/{id}", async (int id, ITeamService service, CancellationToken cancellationToken) =>
            {
                var team = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return team != null ? Results.Ok(team) : Results.NotFound();
            })
          .WithTags(_TeamTag)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_TeamTag), true);

            app.MapPut("/{id}", async (int id, [FromBody] TeamDto teamDto, ITeamService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (teamDto == null)
                {
                    return Results.BadRequest("Team data is required.");
                }
                var existingTeam = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingTeam == null)
                {
                    return Results.NotFound($"Team with ID {id} not found.");
                }

                var updatedKra = await service.SaveOrUpdateAsync(teamDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_TeamTag, cancellationToken);
                return Results.Ok(updatedKra);
            })
           .WithTags(_TeamTag);

            app.MapGet("/page", async (int page, int pageSize, ITeamService service, CancellationToken cancellationToken) =>
            {
                var paginatedTeam = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedTeam);
            })
           .WithTags(_TeamTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_TeamTag), true);


        }
    }

      
}
