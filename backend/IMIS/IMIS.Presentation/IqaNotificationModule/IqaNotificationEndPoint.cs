using Carter;
using IMIS.Application.IqaNotificationModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using System.Threading;

namespace IMIS.Presentation.IqaNotificationModule
{
    /// <summary>
    /// The IQA notifications of the signed-in user. Every user only ever sees
    /// their own, so no permission is needed beyond being signed in.
    /// </summary>
    public class IqaNotificationEndPoints : CarterModule
    {
        private const string _tag = "IQA Notification";

        public IqaNotificationEndPoints() : base("/iqaNotifications")
        {
        }

        private static string UserIdOf(HttpContext httpContext) =>
            httpContext.User.FindFirst("UserId")?.Value ?? string.Empty;

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // The latest notifications and the unread count.
            app.MapGet("/", async (int? limit, IIqaNotificationService service, HttpContext httpContext, CancellationToken cancellationToken) =>
            {
                var result = await service.GetForUserAsync(UserIdOf(httpContext), limit ?? 30, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_tag)
            .RequireAuthorization();

            app.MapPut("/{id:long}/read", async (long id, IIqaNotificationService service, HttpContext httpContext, CancellationToken cancellationToken) =>
            {
                var ok = await service.MarkReadAsync(UserIdOf(httpContext), id, cancellationToken).ConfigureAwait(false);
                return ok ? Results.Ok(new { message = "Marked as read." }) : Results.NotFound();
            })
            .WithTags(_tag)
            .RequireAuthorization();

            app.MapPut("/read-all", async (IIqaNotificationService service, HttpContext httpContext, CancellationToken cancellationToken) =>
            {
                await service.MarkAllReadAsync(UserIdOf(httpContext), cancellationToken).ConfigureAwait(false);
                return Results.Ok(new { message = "All marked as read." });
            })
            .WithTags(_tag)
            .RequireAuthorization();
        }
    }
}
