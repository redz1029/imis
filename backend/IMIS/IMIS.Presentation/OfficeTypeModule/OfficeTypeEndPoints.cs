using Carter;
using IMIS.Application.OfficeModule;
using IMIS.Application.OfficeTypeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.OfficeTypeModule
{
    public class OfficeTypeEndPoints : CarterModule
    {
        private const string _officeType = "Office Type";
        public OfficeTypeEndPoints() : base("/officetype")
        {

        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] OfficeTypeDto officeTypeDto, IOfficeTypeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(officeTypeDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_officeType, cancellationToken);
                return Results.Ok(officeTypeDto);
            })
            .WithTags(_officeType);
            //.RequireAuthorization(e => e.RequireClaim(
            // PermissionClaimType.Claim, _officePermission.Add));
        }
    }

}
