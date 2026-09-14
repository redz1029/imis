using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditChecklistModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditChecklistModule
{
    public class AuditChecklistEndPoints : CarterModule
    {
        private const string _auditChecklist = "Audit Checklist";

        public AuditChecklistEndPoints() : base("/auditchecklist")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE / UPDATE
            app.MapPost("/", async ([FromBody] AuditChecklistDto dto, IAuditChecklistService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditChecklist, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditChecklist);

            // UPDATE (Matches POST logic in your template)
            app.MapPut("/", async ([FromBody] AuditChecklistDto dto, IAuditChecklistService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditChecklist, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditChecklist);
            // GET OR GENERATE FROM AUDIT PLAN ENTRY
            app.MapGet("/planentry/{auditPlanEntryId:int}", async (int auditPlanEntryId, IAuditChecklistService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetOrGenerateForAuditPlanEntryAsync(auditPlanEntryId, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditChecklist)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditChecklist), true);

            // GET BY ID
            app.MapGet("/{id:int}", async (int id, IAuditChecklistService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_auditChecklist)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditChecklist), true);

            // GET BY PROCESS ID
            app.MapGet("/process/{processId:int}", async (int processId, IAuditChecklistService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByProcessIdAsync(processId, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditChecklist)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditChecklist), true);

            // PAGINATED
            app.MapGet("/page", async (int page, int pageSize, IAuditChecklistService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditChecklist)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_auditChecklist), true);

            // DELETE
            app.MapDelete("/{id:int}", async (int id, IAuditChecklistService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_auditChecklist, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_auditChecklist);
        }
    }
}