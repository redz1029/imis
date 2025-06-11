using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PgsPeriodModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsPeriodModuleAPI
{
    public class PgsPeriodEndPoints : CarterModule
    {
        private const string _pgsPeriodTag = "PGS Period";
        public readonly PgsPeriodPermission _pgsPeriodPermission = new();
        public PgsPeriodEndPoints() : base("/pgsPeriod")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PgsPeriodDto pgsPeriodDto, IPgsPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var createdPgsPeriod = await service.SaveOrUpdateAsync(pgsPeriodDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsPeriodTag, cancellationToken);
                return Results.Created($"/pgsPeriod/{createdPgsPeriod.Id}", createdPgsPeriod);
            })
            .WithTags(_pgsPeriodTag)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _pgsPeriodPermission.Add));

            app.MapGet("/", async (IPgsPeriodService service, CancellationToken cancellationToken) =>
            {
                var period = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(period);
            })
            .WithTags(_pgsPeriodTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsPeriodTag), true)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _pgsPeriodPermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] PgsPeriodDto pgsPeriodDto, IPgsPeriodService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                try
                {
                    var existingPeriod = await service.GetByIdAsync(id, cancellationToken);
                    if (existingPeriod == null)
                        return Results.NotFound($"PGS Period with ID {id} not found.");

                    pgsPeriodDto.Id = id;
                    var updated = await service.SaveOrUpdateAsync(pgsPeriodDto, cancellationToken);
                    await cache.EvictByTagAsync(_pgsPeriodTag, cancellationToken);
                    return Results.Ok(updated);
                }
                catch (InvalidOperationException ex) when (ex.InnerException is DbUpdateConcurrencyException)
                {
                    return Results.Conflict("The record was modified by another user. Please reload and try again.");
                }
            })
            .WithTags(_pgsPeriodTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pgsPeriodPermission.Edit));


            app.MapGet("/page", async (int page, int pageSize, IPgsPeriodService service, CancellationToken cancellationToken) =>
            {
                var paginatedPgsPeriod = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedPgsPeriod);
            })
            .WithTags(_pgsPeriodTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsPeriodTag), true)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _pgsPeriodPermission.View));
        }
    }
}
