using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PgsKeyResultAreaModule;
using IMIS.Application.PgsKraModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.KraModuleAPI
{
    public class KraEndPoints : CarterModule
    {
        private const string _keyAreaResultTag = "Key Result Area";
        public readonly KeyResultAreaPermission _keyResultAreaPermission = new();
        public KraEndPoints() : base("/keyResultArea")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] KeyResultAreaDto keyResultAreaDto, IKeyResultAreaService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {               
                var createdKeyResultAreaDto = await service.SaveOrUpdateAsync(keyResultAreaDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_keyAreaResultTag, cancellationToken);
                return Results.Created($"/kra/{createdKeyResultAreaDto.Id}", createdKeyResultAreaDto);
            })
            .WithTags(_keyAreaResultTag)
            .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim, _keyResultAreaPermission.Add, _keyResultAreaPermission.Add));

            app.MapGet("/", async (IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                var keyResultAreaDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(keyResultAreaDto);
            })
            .WithTags(_keyAreaResultTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_keyAreaResultTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _keyResultAreaPermission.View));

            app.MapGet("/filter/{name}", async (string name, IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                int kraNoOfResults = 10;
                var keyResultArea = await service.FilterByName(name, kraNoOfResults, cancellationToken).ConfigureAwait(false);
                return keyResultArea != null ? Results.Ok(keyResultArea) : Results.NoContent();
            })
            .WithTags(_keyAreaResultTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_keyAreaResultTag), true);
            app.MapGet("/{id}", async (int id, IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                var keyResultArea = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return keyResultArea != null ? Results.Ok(keyResultArea) : Results.NotFound();
            })
            .WithTags(_keyAreaResultTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_keyAreaResultTag), true);
            app.MapPut("/{id}", async (int id, [FromBody] KeyResultAreaDto keyResultAreaDto, IKeyResultAreaService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {               
                var existingKeyResultArea = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingKeyResultArea == null)
                {
                    return Results.NotFound($"KeyResultArea with ID {id} not found.");
                }
                
                var updatedKeyResultArea = await service.SaveOrUpdateAsync(keyResultAreaDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_keyAreaResultTag, cancellationToken);
                return Results.Ok(updatedKeyResultArea);
            })
            .WithTags(_keyAreaResultTag);
            app.MapGet("/page", async (int page, int pageSize, IKeyResultAreaService service, CancellationToken cancellationToken) =>
            {
                var paginatedKeyResultArea = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedKeyResultArea);
            })
            .WithTags(_keyAreaResultTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_keyAreaResultTag), true);
        }
    }
}





