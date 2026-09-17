using Carter;
using IMIS.Application.AuditeeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditeeModule
{
    public class AuditeeEndpoint : CarterModule
    {
        private const string _Auditee = "Auditee";

        public AuditeeEndpoint() : base("Auditee")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("Auditee")
                           .WithTags(_Auditee);

            // CREATE / UPDATE//
            group.MapPost("/", async ([FromBody] AuditeeDto dto, IAuditeeService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                if (dto == null) return Results.BadRequest("Request body is required.");

                await service.SaveOrUpdateAsync(dto, ct).ConfigureAwait(false);
                await cache.EvictByTagAsync(_Auditee, ct).ConfigureAwait(false);

                return Results.Ok(new { message = "Auditee saved successfully." });
            });

            // GET ALL
            group.MapGet("/", async (IAuditeeService service, CancellationToken ct) =>
            {
                var result = await service.GetAll(ct).ConfigureAwait(false);
                return result is not null && result.Any() ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_Auditee));

            // GET PAGINATED
            group.MapGet("/paginated", async ([FromQuery] int page, [FromQuery] int pageSize, IAuditeeService service, CancellationToken ct) =>
            {
                if (page <= 0 || pageSize <= 0)
                    return Results.BadRequest("Page parameters must be positive.");

                var result = await service.GetPaginatedAsync(page, pageSize, ct).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NoContent();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_Auditee));

            // GET BY ID
            group.MapGet("/{id:int}", async (int id, IAuditeeService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdAsync(id, ct).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_Auditee));

            // SOFT DELETE
            group.MapDelete("/{id:int}", async (int id, IAuditeeService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var success = await service.SoftDeleteAsync(id, ct).ConfigureAwait(false);
                if (!success) return Results.NotFound(new { message = "Auditee not found." });

                await cache.EvictByTagAsync(_Auditee, ct).ConfigureAwait(false);
                return Results.Ok(new { message = "Auditee deleted successfully." });
            });
        }
    }
}