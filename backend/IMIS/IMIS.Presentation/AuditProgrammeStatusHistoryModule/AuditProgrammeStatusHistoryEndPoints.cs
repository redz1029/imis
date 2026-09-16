using Carter;
using IMIS.Application.AuditProgrammeStatusHistoryModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Threading;

namespace IMIS.Presentation.AuditProgrammeStatusHistoryModule
{
    public class AuditProgrammeStatusHistoryEndPoints : CarterModule
    {
        private const string _tag = "Audit Programme Status History";

        public AuditProgrammeStatusHistoryEndPoints() : base("/auditprogrammestatushistory")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] AuditProgrammeStatusHistoryDto dto, IAuditProgrammeStatusHistoryService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);

            app.MapPut("/", async ([FromBody] AuditProgrammeStatusHistoryDto dto, IAuditProgrammeStatusHistoryService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(dto);
            })
            .WithTags(_tag);

            app.MapGet("/programme/{programmeId:int}", async (int programmeId, IAuditProgrammeStatusHistoryService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByProgrammeIdAsync(programmeId, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_tag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(10)).Tag(_tag), true);

            app.MapGet("/page", async (int page, int pageSize, IAuditProgrammeStatusHistoryService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(result);
            })
            .WithTags(_tag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(10)).Tag(_tag), true);

            app.MapDelete("/{id:int}", async (int id, IAuditProgrammeStatusHistoryService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var (success, error) = await service.SoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
                if (!success) return Results.BadRequest(new { error });

                await cache.EvictByTagAsync(_tag, cancellationToken);
                return Results.Ok(new { Message = "Deleted Successfully" });
            })
            .WithTags(_tag);
        }
    }
}