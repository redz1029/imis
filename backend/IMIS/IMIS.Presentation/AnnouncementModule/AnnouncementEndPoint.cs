using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AnnouncementModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AnnouncementModule
{
    public class AnnouncementEndPoint : CarterModule
    {
        private const string _announcementTag = "Announcement";  
        public readonly AnnouncementPermission _announcementPermission = new();     
        public AnnouncementEndPoint() : base("/announcement")
        {

        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] AnnouncementDto announcement, IAnnouncementService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(announcement, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_announcementTag, cancellationToken);
                return Results.Ok(announcement);
            })
           .WithTags(_announcementTag)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _announcementPermission.Add));

            app.MapGet("/", async (IAnnouncementService service, CancellationToken cancellationToken) =>
            {
                var announcement = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(announcement);
            })
          .WithTags(_announcementTag)
          .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_announcementTag), true)
          .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _announcementPermission.View));

            app.MapGet("/Active", async (IAnnouncementService service, CancellationToken cancellationToken) =>
            {
                var announcement = await service.GetAllActive(cancellationToken).ConfigureAwait(false);
                return Results.Ok(announcement);
            })
           .WithTags(_announcementTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_announcementTag), true);        

            app.MapPut("/{id}", async (int id, [FromBody] AnnouncementDto announcement, IAnnouncementService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existingAnnouncement = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingAnnouncement == null)
                {
                    return Results.NotFound($"Announcement with ID {id} not found.");
                }
                await service.SaveOrUpdateAsync(announcement, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_announcementTag, cancellationToken);
                return Results.Ok(announcement);
            })
           .WithTags(_announcementTag)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _announcementPermission.Edit));

            app.MapDelete("/{id:int}", async (int id, IAnnouncementService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_announcementTag, cancellationToken);

                return result ? Results.Ok(new { message = "Announcement deleted successfully." })
                              : Results.NotFound(new { message = "Announcement not found." });
            })
           .WithTags(_announcementTag)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _announcementPermission.Edit));          
        }
    }
}
