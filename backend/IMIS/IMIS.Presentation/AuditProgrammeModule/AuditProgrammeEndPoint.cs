//using Base.Auths.Permissions;
//using Carter;
//using IMIS.Application.AuditProgrammeModule;
//using IMIS.Infrastructure.Reports;
//using Microsoft.AspNetCore.Builder;
//using Microsoft.AspNetCore.Http;
//using Microsoft.AspNetCore.Mvc;
//using Microsoft.AspNetCore.OutputCaching;
//using Microsoft.AspNetCore.Routing;
//using Microsoft.Extensions.DependencyInjection;

//namespace IMIS.Presentation.AuditProgrammeModule
//{
//    public class AuditProgrammeEndPoints : CarterModule
//    {
//        private const string _AuditProgramme = "AuditProgramme";

//        public AuditProgrammeEndPoints() : base("/auditProgramme")
//        {
//        }

//        public override void AddRoutes(IEndpointRouteBuilder app)
//        {
//            // CREATE
//            app.MapPost("/", async (
//                [FromBody] AuditProgrammeDto dto,
//                IAuditProgrammeService service,
//                IOutputCacheStore cache,
//                CancellationToken cancellationToken) =>
//            {
//                if (dto == null)
//                    return Results.BadRequest("Invalid request.");

//                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken).ConfigureAwait(false);
//                if (conflicts.Count > 0)
//                    return Results.BadRequest(new { Errors = conflicts });

//                var result = await service.SaveAuditProgrammeAsync(dto, cancellationToken).ConfigureAwait(false);

//                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken).ConfigureAwait(false);

//                return result ? Results.Ok(dto) : Results.BadRequest("Failed to save Audit Programme.");
//            })
//            .WithTags(_AuditProgramme);

//            // GET ALL
//            app.MapGet("/", async (
//                IAuditProgrammeService service,
//                CancellationToken cancellationToken) =>
//            {
//                var result = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
//                return result != null ? Results.Ok(result) : Results.Ok(new List<AuditProgrammeDto>());
//            })
//            .WithTags(_AuditProgramme);

//            // =========================================================================
//            // GET BY ID (Calls GetByIdAsync -> GetByIdWithDetailsAsync in Repository)
//            // =========================================================================
//            app.MapGet("/{id:int}", async (
//                int id,
//                IAuditProgrammeService service,
//                CancellationToken cancellationToken) =>
//            {
//                var result = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);

//                return result != null
//                    ? Results.Ok(result)
//                    : Results.NotFound(new { message = $"Audit Programme with ID {id} was not found." });
//            })
//            .WithTags(_AuditProgramme)
//            .RequireCors("AllowAll")
//            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditProgramme), true);

//            // GENERATE PDF REPORT
//            app.MapGet("/PdF/{id:int}", async (
//                HttpResponse response,
//                int id,
//                IAuditProgrammeService service,
//                CancellationToken cancellationToken) =>
//            {
//                var auditData = await service.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);

//                if (auditData == null)
//                    return Results.NotFound(new { message = $"Audit Programme with ID {id} was not found." });

//                var file = await ReportUtil.GeneratePdfReport<ReportAuditProgrammeDto>(
//                    "AuditProgramme",
//                    new List<ReportAuditProgrammeDto> { auditData },
//                    "AuditData",
//                    cancellationToken
//                ).ConfigureAwait(false);

//                return Results.File(file, "application/pdf", $"AuditProgramme_{DateTime.Now:yyyyMMddHHmmss}.pdf");
//            })
//            .WithTags(_AuditProgramme)
//            .RequireCors("AllowAll")
//            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditProgramme), true);

//            // UPDATE
//            app.MapPut("/{id:int}", async (
//                int id,
//                [FromBody] AuditProgrammeDto dto,
//                IAuditProgrammeService service,
//                IOutputCacheStore cache,
//                CancellationToken cancellationToken) =>
//            {
//                if (dto == null)
//                    return Results.BadRequest("Invalid request.");

//                var conflicts = await service.GetConflictValidationsAsync(dto, cancellationToken).ConfigureAwait(false);
//                if (conflicts.Count > 0)
//                    return Results.BadRequest(new { Errors = conflicts });

//                dto.Id = id;

//                var result = await service.SaveAuditProgrammeAsync(dto, cancellationToken).ConfigureAwait(false);

//                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken).ConfigureAwait(false);

//                return result ? Results.Ok(dto) : Results.BadRequest("Failed to update Audit Programme.");
//            })
//            .WithTags(_AuditProgramme);

//            // PAGINATION
//            app.MapGet("/page", async (
//                [FromQuery] int page,
//                [FromQuery] int pageSize,
//                IAuditProgrammeService service,
//                CancellationToken cancellationToken) =>
//            {
//                var pageIndex = page <= 0 ? 1 : page;
//                var size = pageSize <= 0 ? 10 : pageSize;

//                var result = await service.GetPaginatedAsync(pageIndex, size, cancellationToken).ConfigureAwait(false);
//                return Results.Ok(result);
//            })
//            .WithTags(_AuditProgramme);

//            // DELETE
//            app.MapDelete("/{id:int}", async (
//                int id,
//                IAuditProgrammeService service,
//                IOutputCacheStore cache,
//                CancellationToken cancellationToken) =>
//            {
//                var result = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);

//                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken).ConfigureAwait(false);

//                return result
//                    ? Results.Ok(new { message = "Audit Programme deleted successfully." })
//                    : Results.NotFound(new { message = "Audit Programme not found." });
//            })
//            .WithTags(_AuditProgramme);
//        }
//    }
//}

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

                await cache.EvictByTagAsync(_AuditProgramme, cancellationToken).ConfigureAwait(false);

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

            // =========================================================================
            // GET BY ID (Calls GetByIdAsync -> GetByIdWithDetailsAsync in Repository)
            // =========================================================================
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

                return result ? Results.Ok(dto) : Results.BadRequest("Failed to update Audit Programme.");
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

                return result
                    ? Results.Ok(new { message = "Audit Programme deleted successfully." })
                    : Results.NotFound(new { message = "Audit Programme not found." });
            })
            .WithTags(_AuditProgramme);
        }
    }
}