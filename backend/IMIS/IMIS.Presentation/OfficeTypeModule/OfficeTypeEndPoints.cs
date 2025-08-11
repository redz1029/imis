using Base.Auths.Permissions;
using Carter;
using IMIS.Application.OfficeTypeModule;
using IMIS.Application.PgsKraModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.OfficeTypeModule
{
    public class OfficeTypeEndPoints : CarterModule
    {
        private const string _officeType = "Office Type";
        public readonly OfficeTypePermission _officeTypePermission = new();
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
            .WithTags(_officeType)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _officeTypePermission.Add));
            app.MapGet("/", async (IOfficeTypeService service, CancellationToken cancellationToken) =>
            {
                var officeTypeDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(officeTypeDto);
            })
          .WithTags(_officeType)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _officeTypePermission.View))
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_officeType), true);
        }
    }

}
