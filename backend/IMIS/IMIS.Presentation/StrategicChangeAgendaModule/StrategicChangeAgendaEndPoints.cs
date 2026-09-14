using Base.Auths.Permissions;
using Carter;
using IMIS.Application.StrategicChangeAgendaModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.StrategicChangeAgendaModule
{
    public class StrategicChangeAgendaEndPoints : CarterModule
    {
        private const string _strategicChangeAgenda = "Strategic Change Agenda"; 
        public readonly StrategicChangeAgendaPermission _strategicChangeAgendaPermission = new();
        public StrategicChangeAgendaEndPoints() : base("/strategicChangeAgenda")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] StrategicChangeAgendaDto dto, IStrategicChangeAgendaService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_strategicChangeAgenda, cancellationToken);
                return Results.Ok(dto);
            })
           .WithTags(_strategicChangeAgenda)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategicChangeAgendaPermission.Add));

            app.MapGet("/{id:long}", async (long id, IStrategicChangeAgendaService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);

                if (result == null)
                    return Results.NotFound();
                return Results.Ok(result);
            })
           .WithTags(_strategicChangeAgenda)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_strategicChangeAgenda), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategicChangeAgendaPermission.View));

            app.MapPut("/update", async ([FromBody] StrategicChangeAgendaDto dto, IStrategicChangeAgendaService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_strategicChangeAgenda, cancellationToken);
                return Results.Ok(dto);
            })
           .WithTags(_strategicChangeAgenda)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategicChangeAgendaPermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IStrategicChangeAgendaService service, CancellationToken cancellationToken) =>
            {
                var paginatedPgsPeriod = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedPgsPeriod);
            })
           .WithTags(_strategicChangeAgenda)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_strategicChangeAgenda), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategicChangeAgendaPermission.View));

            app.MapDelete("/{id:int}", async (int id, IStrategicChangeAgendaService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_strategicChangeAgenda, cancellationToken);

                return result ? Results.Ok(new { message = " Agenda deleted successfully." }) : Results.NotFound(new { message = "Review not found." });
            })
           .WithTags(_strategicChangeAgenda)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _strategicChangeAgendaPermission.Delete));
        }
    }
}
