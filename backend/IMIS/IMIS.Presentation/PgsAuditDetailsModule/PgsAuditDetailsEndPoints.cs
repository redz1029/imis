using Carter;
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

              app.MapGet("/page", async (int page, int pageSize, IUserOfficeService service, CancellationToken cancellationToken) =>
              {
                  var paginatedUserOffice = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                  return paginatedUserOffice;
              })
            .WithTags(_pgsTag)
            .RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);
                        
        }
    }
}
