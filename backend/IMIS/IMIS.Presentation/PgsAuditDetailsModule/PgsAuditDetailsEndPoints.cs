using Carter;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.UserOfficeModule;
using IMIS.Infrastructure.Auths;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsModuleAPI
{
    public class PgsAuditDetailsEndPoints : CarterModule
    {
        private const string _pgsTag = "Create PgsAuditDetails";

        public PgsAuditDetailsEndPoints() : base("/PgsAuditDetails")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PgsAuditDetailsDto PgsAuditDetailsDto, IPgsAuditDetailsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (PgsAuditDetailsDto == null)
                {
                    return Results.BadRequest("PGS Audit Details data is required.");
                }
                var createdOrUpdatedPgsAuditDeatails = await service.SaveOrUpdateAsync(PgsAuditDetailsDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Created($"/PgsAuditDetails/{createdOrUpdatedPgsAuditDeatails.Id}", createdOrUpdatedPgsAuditDeatails);

            })
            .WithTags(_pgsTag);

            app.MapGet("/", async (IPgsAuditDetailsService service, CancellationToken cancellationToken) =>
            {
                var PgsAuditDetails = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(PgsAuditDetails);
            })
           .WithTags(_pgsTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

            app.MapGet("/{id}", async (int id, IPgsAuditDetailsService service, CancellationToken cancellationToken) =>
            {
                var PgsAuditDetails = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return PgsAuditDetails != null ? Results.Ok(PgsAuditDetails) : Results.NotFound();
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

            app.MapPut("/{id}", async (int id, [FromBody] PgsAuditDetailsDto PgsAuditDetails, IPgsAuditDetailsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (PgsAuditDetails == null)
                {
                    return Results.BadRequest("Kra data is required.");
                }
                var existingPgsAuditDetails = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingPgsAuditDetails == null)
                {
                    return Results.NotFound($"PgsAuditDetails with ID {id} not found.");
                }

                var updatedexistingPgsAuditDetails = await service.SaveOrUpdateAsync(PgsAuditDetails, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Ok(updatedexistingPgsAuditDetails);
            })
           .WithTags(_pgsTag);

            app.MapGet("/page", async (int page, int pageSize, IPgsAuditDetailsService service, CancellationToken cancellationToken) =>
            {
                var paginatedAuditDetails = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedAuditDetails;
            })
            .WithTags(_pgsTag)
            .RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

        }
    }
}
