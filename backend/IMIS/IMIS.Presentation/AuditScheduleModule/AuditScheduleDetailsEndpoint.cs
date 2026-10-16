using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditScheduleModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Presentation.AuditScheduleModule
{
    public class AuditScheduleDetailsEndpoint : CarterModule
    {
        private const string _auditScheduleDetailsTag = "AuditScheduleDetails";

        public AuditScheduleDetailsEndpoint() : base("/auditScheduleDetails")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // --- CREATE / UPDATE ---
            app.MapPost("/", async (
                [FromBody] AuditScheduleDetailsDto dto,
                [FromServices] IAuditScheduleDetailsService service,
                [FromServices] IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditScheduleDetailsTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditScheduleDetailsTag);

            // --- GET ALL ---
            app.MapGet("/", async (
                [FromServices] IAuditScheduleDetailsService service,
                CancellationToken cancellationToken) =>
            {
                var details = await service.GetAll(cancellationToken).ConfigureAwait(false);
                return Results.Ok(details);
            })
            .WithTags(_auditScheduleDetailsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditScheduleDetailsTag), true);

            // --- GET PAGINATED ---
            app.MapGet("/page", async (
                [FromQuery] int page,
                [FromQuery] int pageSize,
                [FromServices] IAuditScheduleDetailsService service,
                CancellationToken cancellationToken) =>
            {
                var paginated = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginated is not null
                    ? Results.Ok(paginated)
                    : Results.NoContent();
            })
            .WithTags(_auditScheduleDetailsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditScheduleDetailsTag), true);

            // --- UPDATE BY ID ---
            app.MapPut("/{id:int}", async (
                int id,
                [FromBody] AuditScheduleDetailsDto dto,
                [FromServices] IAuditScheduleDetailsService service,
                [FromServices] IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var existing = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existing == null)
                {
                    return Results.NotFound(new { message = $"Schedule Detail with ID {id} not found." });
                }

                dto.Id = id;
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditScheduleDetailsTag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditScheduleDetailsTag);

            // --- DELETE (SOFT DELETE) ---
            app.MapDelete("/{id:int}", async (
                int id,
                [FromServices] IAuditScheduleDetailsService service,
                [FromServices] IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);
                if (result)
                {
                    await cache.EvictByTagAsync(_auditScheduleDetailsTag, cancellationToken);
                    return Results.Ok(new { message = "Audit Schedule Detail deleted successfully." });
                }

                return Results.NotFound(new { message = "Audit Schedule Detail not found." });
            })
            .WithTags(_auditScheduleDetailsTag);
        }
    }
}