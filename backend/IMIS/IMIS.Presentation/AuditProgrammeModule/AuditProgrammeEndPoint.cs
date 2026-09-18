using Base.Auths.Permissions;
using Carter;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditProgrammeModule
{
    public class AuditProgrammeEndPoints : CarterModule
    {
        private const string _AuditProgramme = "AuditProgramme";

        // NEW — must match the exact tag strings used by AuditPlanEndPoints.cs
        // and AuditSchedulesEndPoints.cs's own .CacheOutput(...).Tag(...) calls.
        // Confirm these two literal strings against those files; if either
        // differs even by casing, the eviction silently misses and this bug
        // persists for that one endpoint.
        private const string _AuditPlan = "Audit Plan";
        private const string _AuditSchedule = "Audit Schedule";

        public AuditProgrammeEndPoints() : base("/auditProgramme")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // CREATE
            app.MapPost("/", async (
                [FromBody] AuditProgrammeDto dto,
                IAuditProgrammeService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken).ConfigureAwait(false);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                var result = await service.SaveAuditProgrammeAsync(dto, cancellationToken).ConfigureAwait(false);

                // A Programme save cascades into AuditPlan (and its own
                // cascade into AuditSchedule) — every affected tag must be
                // evicted, not just this endpoint's own, or those lists keep
                // serving stale cached data until their TTL happens to expire.
                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditPlan, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken).ConfigureAwait(false);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to save Audit Programme.");
            })
            .WithTags(_AuditProgramme);

            // GET ALL
            app.MapGet("/", async (
                IAuditProgrammeService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return result != null ? Results.Ok(result) : Results.Ok(new List<AuditProgrammeDto>());
            })
            .WithTags(_AuditProgramme);

            app.MapGet("/{id:int}", async (
                int id,
                IAuditProgrammeService service,
                CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);

                return result != null
                    ? Results.Ok(result)
                    : Results.NotFound(new { message = $"Audit Programme with ID {id} was not found." });
            })
            .WithTags(_AuditProgramme)
            .RequireCors("_allowedOrigins")
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditProgramme), true);

            // GENERATE PDF REPORT
            app.MapGet("/PdF/{id:int}", async (
                HttpResponse response,
                int id,
                IAuditProgrammeService service,
                CancellationToken cancellationToken) =>
            {
                var auditData = await service.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);

                if (auditData == null)
                    return Results.NotFound(new { message = $"Audit Programme with ID {id} was not found." });

                var file = await ReportUtil.GeneratePdfReport<ReportAuditProgrammeDto>(
                    "AuditProgramme",
                    new List<ReportAuditProgrammeDto> { auditData },
                    "AuditData",
                    cancellationToken
                ).ConfigureAwait(false);

                return Results.File(file, "application/pdf", $"AuditProgramme_{DateTime.Now:yyyyMMddHHmmss}.pdf");
            })
            .WithTags(_AuditProgramme)
            .RequireCors("_allowedOrigins")
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditProgramme), true);

            // UPDATE
            app.MapPut("/{id:int}", async (
                int id,
                [FromBody] AuditProgrammeDto dto,
                IAuditProgrammeService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto == null)
                    return Results.BadRequest("Invalid request.");

                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken).ConfigureAwait(false);
                if (conflicts.Count > 0)
                    return Results.BadRequest(new { Errors = conflicts });

                dto.Id = id;

                var result = await service.SaveAuditProgrammeAsync(dto, cancellationToken).ConfigureAwait(false);

                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditPlan, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken).ConfigureAwait(false);

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to update Audit Programme.");
            })
            .WithTags(_AuditProgramme);

            // SUBMIT
            app.MapPut("/{id:int}/submit", async (
                int id,
                IAuditProgrammeService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var (success, error) = await service.SubmitAsync(id, cancellationToken).ConfigureAwait(false);

                if (!success)
                    return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditPlan, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken).ConfigureAwait(false);
                return Results.Ok(new { message = "Submitted for approval." });
            })
            .WithTags(_AuditProgramme);

            // DECIDE — Pending -> Approved/Disapproved
            app.MapPut("/{id:int}/decide", async (
                int id,
                [FromBody] DecideAuditProgrammeRequest dto,
                IAuditProgrammeService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (dto is null)
                    return Results.BadRequest("Invalid request.");

                var (success, error) = await service.DecideAsync(
                    id, dto.ApproverId, dto.Approve, dto.Comments, cancellationToken
                ).ConfigureAwait(false);

                if (!success)
                    return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditPlan, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken).ConfigureAwait(false);
                return Results.Ok(new { message = dto.Approve ? "Approved." : "Disapproved." });
            })
            .WithTags(_AuditProgramme);

            // PAGINATION
            app.MapGet("/page", async (
                [FromQuery] int page,
                [FromQuery] int pageSize,
                IAuditProgrammeService service,
                CancellationToken cancellationToken) =>
            {
                var pageIndex = page <= 0 ? 1 : page;
                var size = pageSize <= 0 ? 10 : pageSize;

                var result = await service.GetPaginatedAsync(pageIndex, size, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_AuditProgramme);

            // DELETE
            app.MapDelete("/{id:int}", async (
                int id,
                IAuditProgrammeService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);

                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditPlan, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken).ConfigureAwait(false);

                return result
                    ? Results.Ok(new { message = "Audit Programme deleted successfully." })
                    : Results.NotFound(new { message = "Audit Programme not found." });
            })
            .WithTags(_AuditProgramme);
        }
        public record DecideAuditProgrammeRequest(string ApproverId, bool Approve, string? Comments);
    }
}