using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditChecklistQNAModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditChecklistQNAModule
{
    public class AuditChecklistQNAEndPoints : CarterModule
    {
        private const string _auditChecklistQNA = "Audit Checklist QNA";

        public AuditChecklistQNAEndPoints() : base("/auditchecklistqna")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE / UPDATE
            app.MapPost("/", async ([FromBody] AuditChecklistQNADto dto, IAuditChecklistQNAService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditChecklistQNA, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditChecklistQNA);

            // UPDATE
            app.MapPut("/", async ([FromBody] AuditChecklistQNADto dto, IAuditChecklistQNAService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_auditChecklistQNA, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_auditChecklistQNA);

            // GET BY ID
            app.MapGet("/{id:int}", async (int id, IAuditChecklistQNAService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return result is not null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_auditChecklistQNA);

            // GET ALL BY CHECKLIST ID
            app.MapGet("/checklist/{checklistId:int}", async (int checklistId, IAuditChecklistQNAService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByChecklistIdAsync(checklistId, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditChecklistQNA);

            // PAGINATED
            app.MapGet("/page", async (int page, int pageSize, IAuditChecklistQNAService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_auditChecklistQNA);

            // SOFT DELETE
            app.MapDelete("/{id:int}", async (int id, IAuditChecklistQNAService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var success = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_auditChecklistQNA, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_auditChecklistQNA);
        }
    }
}