using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Application.PgsModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System.Text.Json;

namespace IMIS.Presentation.PGSModule
{
    public class PGSDeliverableEndpoints : CarterModule
    {
        private const string _pgsTag = "PGS Deliverable";
        public readonly PgsDeliverablePermission _pgsDeliverablePermission = new();
        public readonly PgsDeliverableAuditorPermission _pgsDeliverableAuditorPermission = new();
        public readonly PgsDeliverableServiceHeadPermission _pgsDeliverableServiceHeadPermission = new();
        public PGSDeliverableEndpoints() : base("/deliverables")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] List<PGSDeliverableDto> pgsDtos, IPGSDeliverableService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (pgsDtos == null || !pgsDtos.Any())
                {
                    return Results.BadRequest("PGS data list is required.");
                }

                var createdPgsList = new List<PGSDeliverableDto>();

                foreach (var pgsDto in pgsDtos)
                {
                    if (pgsDto.Id == 0)
                    {
                        pgsDto.Id = 0;
                    }
                    var createdPgs = await service.SaveOrUpdateAsync(pgsDto, cancellationToken).ConfigureAwait(false);
                    await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                    createdPgsList.Add(createdPgs);
                }
                // Log response
                Console.WriteLine($"Created PGS Count: {createdPgsList.Count}");
                Console.WriteLine("Created Deliverables:");
                Console.WriteLine(JsonSerializer.Serialize(createdPgsList, new JsonSerializerOptions { WriteIndented = true }));
                return Results.Created("/Deliverable", createdPgsList);
            })
            .WithTags(_pgsTag)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _pgsDeliverablePermission.Add));

            app.MapGet("/", async (IPGSDeliverableService service, CancellationToken cancellationToken) =>
            {
                var Kradto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(Kradto);
            })  
            .WithTags(_pgsTag)
            .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim, _pgsDeliverablePermission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

            app.MapPut("/{id}", async (int id, [FromBody] PGSDeliverableDto pgsdeliverables, IPGSDeliverableService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (pgsdeliverables == null)
                {
                    return Results.BadRequest("Pgs Deliverable data is required.");
                }
                var existingPgsDeliverables = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingPgsDeliverables == null)
                {
                    return Results.NotFound($"User Office with ID {id} not found.");
                }

                var updatedPgsDeliverables = await service.SaveOrUpdateAsync(pgsdeliverables, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Ok(updatedPgsDeliverables);
            })
            .WithTags(_pgsTag)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _pgsDeliverablePermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IPGSDeliverableService service, CancellationToken cancellationToken) =>
            {
                var paginatedPgsDeliverables = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedPgsDeliverables);
            })
            .WithTags(_pgsTag)
            .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim, _pgsDeliverablePermission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

            app.MapGet("/filter", async ([AsParameters] PgsDeliverableMonitorFilter filter, IPGSDeliverableService service, CancellationToken cancellationToken) =>
            {
                var filteredPgsDeliverables = await service.GetFilteredAsync(filter, cancellationToken).ConfigureAwait(false);
                return Results.Ok(filteredPgsDeliverables);
            })
            .WithTags(_pgsTag)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _pgsDeliverableAuditorPermission.View, _pgsDeliverableServiceHeadPermission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);





            app.MapPut("/filter/update", async ([FromBody] PgsDeliverableMonitorPageList request, IPGSDeliverableService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.UpdateDeliverablesAsync(request, cache, cancellationToken);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);

                return Results.Ok(result);
            })
            .WithTags(_pgsTag)
            .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim,
            _pgsDeliverableAuditorPermission.Score,
            _pgsDeliverableAuditorPermission.View));

        }
    }
}
