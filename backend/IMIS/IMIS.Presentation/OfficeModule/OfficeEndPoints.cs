using Base.Auths.Permissions;
using Carter;
using IMIS.Application.OfficeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.OfficeModule
{
    public class OfficeEndPoints : CarterModule
    {
        private const string _officeTag = "Office";

        public readonly OfficePermission _officePermission = new();
        public OfficeEndPoints() : base("/office")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
           
            app.MapPost("/", async ([FromBody] OfficeDto officeDto, IOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (officeDto.ParentOfficeId != null && officeDto.Id == officeDto.ParentOfficeId)
                {
                    return Results.BadRequest("An office cannot be its own parent.");
                }

                if (await service.HasCircularReferenceAsync(officeDto.ParentOfficeId, officeDto.Id, cancellationToken))
                {
                    return Results.BadRequest("Circular parent relationship detected.");
                }

                await service.SaveOrUpdateAsync(officeDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_officeTag, cancellationToken);
                return Results.Ok(officeDto);
            })
             .WithTags(_officeTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _officePermission.Add));

            app.MapGet("/", async (IOfficeService service, CancellationToken cancellationToken) =>
            {
                var offices = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(offices);
            })
            .WithTags(_officeTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _officePermission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_officeTag), true);

            //// Get offices filtered for PGS Auditor
            app.MapGet("/pgs-auditor", async (IOfficeService service, CancellationToken cancellationToken) =>
            {
                var offices = await service.GetOfficesForPgsAuditorAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(offices);
            })
            .WithTags(_officeTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _officePermission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_officeTag), true);
         
            app.MapGet("/filter/{name}", async (string name, IOfficeService service, CancellationToken cancellationToken) =>
            {
                int officeNoOfResults = 10;
                var offices = await service.FilterByName(name, officeNoOfResults, cancellationToken).ConfigureAwait(false);
                return offices != null ? Results.Ok(offices) : Results.NoContent();
            })
            .WithTags(_officeTag)          
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_officeTag), true);

            app.MapGet("/{id}", async (int id, IOfficeService service, CancellationToken cancellationToken) =>
            {
                var office = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return office != null ? Results.Ok(office) : Results.NotFound();
            })
            .WithTags(_officeTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _officePermission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_officeTag), true);

            app.MapPut("/{id}", async (int id, [FromBody] OfficeDto office, IOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                // Validate: Office cannot be its own parent
                if (office.ParentOfficeId != null && office.ParentOfficeId == id)
                {
                    return Results.BadRequest("An office cannot be its own parent.");
                }
                if (await service.HasCircularReferenceAsync(office.ParentOfficeId, office.Id, cancellationToken))
                {
                    return Results.BadRequest("Circular parent relationship detected.");
                }
                var existingOffice = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingOffice == null)
                {
                    return Results.NotFound($"Office with ID {id} not found.");
                }
                await service.SaveOrUpdateAsync(office, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_officeTag, cancellationToken);
                return Results.Ok(office);
            })
            .WithTags(_officeTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _officePermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IOfficeService service, CancellationToken cancellationToken) =>
            {
                var paginatedOffice = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedOffice;
            })
            .WithTags(_officeTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_officeTag), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _officePermission.View));

            app.MapDelete("/{id:int}", async (int id, IOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_officeTag, cancellationToken);

                return result ? Results.Ok(new { message = "Office deleted successfully." })
                              : Results.NotFound(new { message = "Office not found." });
            })
            .WithTags(_officeTag)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _officePermission.Edit));
        }
    }
}

