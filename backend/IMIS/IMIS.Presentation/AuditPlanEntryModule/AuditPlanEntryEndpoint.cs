using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Application.KraRoadMapPeriodModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditPlanEntryModule
{
    public class AuditPlanEntryEndpoint : CarterModule
    {
        private const string _tag = "AuditPlanEntry";
        public readonly AuditPlanEntryPermission _AuditPlanEntryPermission = new();

        public AuditPlanEntryEndpoint() : base("/auditplanentries")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // --- READ OPERATIONS ---

            // GET ALL
            app.MapGet("/", async (IAuditPlanEntryService service, CancellationToken ct) =>
            {
                var result = await service.GetAllAsync(ct);
                return result != null ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_tag);

            // GET BY ID
            app.MapGet("/{id:int}", async (int id, IAuditPlanEntryService service, CancellationToken ct) =>
            {
                var result = await service.GetByIdAsync(id, ct);
                return result != null ? Results.Ok(result) : Results.NotFound("Audit Plan Entry not found.");
            })
            .WithTags(_tag);

            // PAGINATION - Explicitly using FromQuery for clarity
            app.MapGet("/page", async ([FromQuery] int page, [FromQuery] int pageSize, IAuditPlanEntryService service, CancellationToken ct) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, ct);
                return result != null ? Results.Ok(result) : Results.NoContent();
            })
            .WithTags(_tag)
            .CacheOutput(b => b.Expire(TimeSpan.FromMinutes(2)).Tag(_tag), true);

            // --- FILTERED QUERIES ---

            app.MapGet("/plan/{auditPlanId:int}", async (int auditPlanId, IAuditPlanEntryService service, CancellationToken ct) =>
            {
                var result = await service.GetByAuditPlanIdAsync(auditPlanId, ct);
                return Results.Ok(result);
            })
            .WithTags(_tag);

            // FIX: Changed auditorId to string to match User Entity (Identity)
            app.MapGet("/auditor/{auditorId}", async (string auditorId, IAuditPlanEntryService service, CancellationToken ct) =>
            {
                var result = await service.GetByAuditorIdAsync(auditorId, ct);
                return Results.Ok(result);
            })
            .WithTags(_tag);

            app.MapGet("/office/{officeId:int}", async (int officeId, IAuditPlanEntryService service, CancellationToken ct) =>
            {
                var result = await service.GetByOfficeIdAsync(officeId, ct);
                return Results.Ok(result);
            })
            .WithTags(_tag);

            app.MapGet("/process/{processId:int}", async (int processId, IAuditPlanEntryService service, CancellationToken ct) =>
            {
                var result = await service.GetByProcessIdAsync(processId, ct);
                return Results.Ok(result);
            })
            .WithTags(_tag);

            // --- WRITE OPERATIONS ---

            // CREATE / UPDATE SINGLE (Standardized with SaveOrUpdate)
            app.MapPost("/", async ([FromBody] AuditPlanEntryDto dto, IAuditPlanEntryService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                if (dto == null) return Results.BadRequest("Data is required.");

                await service.SaveOrUpdateAsync(dto, ct);
                await cache.EvictByTagAsync(_tag, ct);

                return Results.Ok(dto);
            })
            .WithTags(_tag);

            // BULK POST (Referencing your IsoStandard list pattern)
            app.MapPost("/bulk", async ([FromBody] List<AuditPlanEntryDto> dtos, IAuditPlanEntryService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                if (dtos == null || !dtos.Any()) return Results.BadRequest("Data list is required.");

                foreach (var dto in dtos)
                {
                    await service.SaveOrUpdateAsync(dto, ct);
                }

                await cache.EvictByTagAsync(_tag, ct);
                return Results.Ok(new { message = "Bulk operation successful." });
            })
            .WithTags(_tag);

            app.MapPut("/{id:int}", async (int id, [FromBody] AuditPlanEntryDto dto, IAuditPlanEntryService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var existing = await service.GetByIdAsync(id, ct);
                if (existing == null) return Results.NotFound($"Entry with ID {id} not found.");

                dto.Id = id;
                await service.SaveOrUpdateAsync(dto, ct);
                await cache.EvictByTagAsync(_tag, ct);

                return Results.Ok(dto);
            })
            .WithTags(_tag);

            app.MapDelete("/{id:int}", async (int id, IAuditPlanEntryService service, IOutputCacheStore cache, CancellationToken ct) =>
            {
                var success = await service.SoftDeleteAsync(id, ct);
                if (!success) return Results.NotFound();

                await cache.EvictByTagAsync(_tag, ct);
                return Results.Ok(new { message = "Entry deleted successfully." });
            })
            .WithTags(_tag);
        }
    }
}