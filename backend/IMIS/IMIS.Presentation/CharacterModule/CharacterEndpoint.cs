
using Carter;
using IMIS.Application.CharacterModule;
using IMIS.Application.PgsKeyResultAreaModule;
using IMIS.Application.PgsKraModule;
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
        private const string _Character = "Character";

        public CharacterEndpoint() : base("/Character")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] CharacterDto dto, ICharacterService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_Character, cancellationToken);
                return Results.Ok(dto);
            })
          .WithTags(_Character);

            app.MapGet("/", async (ICharacterService service, CancellationToken cancellationToken) =>
            {
                var keyResultAreaDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(keyResultAreaDto);
            })
           .WithTags(_Character)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_Character), true)
           ;
        }
    }
}
