using Carter;
using IMIS.Application.PgsModule;
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
            app.MapPost("/", async ([FromBody] PgsAuditDetailsDto PgsDto, IPgsAuditDetailsService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (PgsDto == null)
                {
                    return Results.BadRequest("PGS data is required.");
                }        
                var createdOrUpdatedPgs = await service.SaveOrUpdateAsync(PgsDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Created($"/PgsAudit/{createdOrUpdatedPgs.Id}", createdOrUpdatedPgs);

            })
            .WithTags(_pgsTag);

            app.MapGet("/Page", async ([FromQuery] int page, [FromQuery] int pageSize, IPgsAuditDetailsService service, CancellationToken cancellationToken) =>
            {
                if (page <= 0 || pageSize <= 0)
                {
                    return Results.BadRequest("Page and PageSize must be greater than 0.");
                }

                var pagedResult = await service.GetPagedPgsAsync(page, pageSize, cancellationToken);
                return Results.Ok(pagedResult);
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

        }
    }
}
