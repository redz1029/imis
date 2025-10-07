using Base.Auths.Permissions;
using Carter;
using IMIS.Application.TeamModule;
using IMIS.Application.UserOfficeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc; 
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.UserOfficeModule
{
    public class UserOfficeEndPoints : CarterModule
    {
        private const string _userOffice = "User Office";
        public readonly UserOfficePermission _userOfficePermission = new();
        public UserOfficeEndPoints() : base("/userOffice") { }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] UserOfficeDto userOfficeDto, IUserOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {                              
                await service.SaveOrUpdateAsync(userOfficeDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_userOffice, cancellationToken);
                return Results.Ok(userOfficeDto);
            })
            .WithTags(_userOffice)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _userOfficePermission.Add));

            app.MapGet("/", async (IUserOfficeService service, CancellationToken cancellationToken) =>
            {
                var userOffice = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(userOffice);
            })
            .WithTags(_userOffice)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _userOfficePermission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_userOffice), true);
 
            app.MapGet("/{id}", async (int id, IUserOfficeService service, CancellationToken cancellationToken) =>
            {
                var userOffice = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return userOffice != null ? Results.Ok(userOffice) : Results.NotFound();
            })
            .WithTags(_userOffice)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_userOffice), true)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _userOfficePermission.View));

            app.MapPut("/{id}", async (int id, [FromBody] UserOfficeDto useroffice, IUserOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (useroffice == null)
                {
                    return Results.BadRequest("User Office data is required.");
                }
                var existingUserOffice = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingUserOffice == null)
                {
                    return Results.NotFound($"User Office with ID {id} not found.");
                }
                await service.SaveOrUpdateAsync(useroffice, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_userOffice, cancellationToken);
                return Results.Ok(useroffice);
            })
            .WithTags(_userOffice)
            .RequireAuthorization(e => e.RequireClaim(
             PermissionClaimType.Claim, _userOfficePermission.Edit));

            app.MapGet("/page", async (int page, int pageSize, IUserOfficeService service, CancellationToken cancellationToken) =>
            {
                var paginatedUserOffice = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedUserOffice;

            })
            .WithTags(_userOffice)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_userOffice), true)
            .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim, _userOfficePermission.View));

            app.MapDelete("/{id:int}", async (int id, IUserOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_userOffice, cancellationToken);

                return result ? Results.Ok(new { message = "User Office deleted successfully." })
                              : Results.NotFound(new { message = "User Office Template not found." });
            })
            .WithTags(_userOffice)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _userOfficePermission.Edit));
        }
    }
}
