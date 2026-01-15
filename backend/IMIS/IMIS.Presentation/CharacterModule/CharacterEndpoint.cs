using Carter;
using IMIS.Application.CharacterModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;


namespace IMIS.Presentation.CharacterModule
{
    public class CharacterEndpoint : CarterModule
    {
        private const string _character = "Character";

        public CharacterEndpoint() : base("/Character")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] CharacterDto dto, ICharacterService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await save(dto, service, cancellationToken);
                await cache.EvictByTagAsync(_character, cancellationToken);
                return Results.Ok(dto);
            })
          .WithTags(_character);

            app.MapGet("/", async (ICharacterService service, CancellationToken cancellationToken) =>
            {
                var CharacterDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(CharacterDto);
            })
           .WithTags(_character)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_character), true);

            app.MapGet("/{id}", async (int id, ICharacterService service, CancellationToken cancellationToken) =>
            {
                var Character = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return Character != null ? Results.Ok(Character) : Results.NotFound();
            })
           .WithTags(_character)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_character), true);


            app.MapGet("/filter/{name}", async (string name, ICharacterService service, CancellationToken cancellationToken) =>
            {
                int CharacterNoOfResults = 10;
                var Character = await service.FilterByName(name, CharacterNoOfResults, cancellationToken).ConfigureAwait(false);
                return Character != null ? Results.Ok(Character) : Results.NoContent();
            })
            .WithTags(_character)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_character), true);

            app.MapGet("/page", async (int page, int pageSize, ICharacterService service, CancellationToken cancellationToken) =>
            {
                var paginatedCharacter = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedCharacter);
            })
           .WithTags(_character)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_character), true);

            app.MapDelete("/{id:int}", async (int id, ICharacterService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_character, cancellationToken);

                return result ? Results.Ok(new { message = "Character deleted successfully." })
                              : Results.NotFound(new { message = "Character not found." });
            })
                .WithTags(_character);

            app.MapPut("/{id}", async (int id, [FromBody] CharacterDto characterDto, ICharacterService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existingCharacter = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingCharacter == null)
                {
                    return Results.NotFound($"Character with ID {id} not found.");
                }
                await service.SaveOrUpdateAsync(characterDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_character, cancellationToken);
                return Results.Ok(characterDto);
            })
        .WithTags(_character);
       


        }

        private static Task save(CharacterDto dto, ICharacterService service, CancellationToken cancellationToken)
        {
            return service.SaveOrUpdateAsync(dto, cancellationToken);
        }
    }
}
