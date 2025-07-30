
using Base.Auths.Permissions;
using Carter;
using IMIS.Application.PgsDeliverableHistoryModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsDeliverableHistoryModule
{
    public class PgsDeliverableHistoryEndPoints : CarterModule
    {
        private const string _pgsTag = "Pgs Deliverable History";
        public readonly PgsDeliverableHistoryPermission _pgsDeliverableHistoryPermission = new();
        public PgsDeliverableHistoryEndPoints() : base("/pgsDeliverableHistory")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {

            app.MapGet("/{id}", async (int id, IPgsDeliverableHistoryService service, CancellationToken cancellationToken) =>
            {
                var pgsDeliverableHistory = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return pgsDeliverableHistory != null ? Results.Ok(pgsDeliverableHistory) : Results.NotFound();
            })
          .WithTags(_pgsTag)        
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true)
          .RequireAuthorization(e => e.RequireClaim(
          PermissionClaimType.Claim, _pgsDeliverableHistoryPermission.View)); ;
        }
    }
}
