using Carter;
using IMIS.Application.AuditableOfficesModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.PgsKraModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.AuditScheduleModule
{
    public class AuditScheduleEndPoints : CarterModule
    {
        private const string _AuditSchedule = "AuditSchedule";
        public AuditScheduleEndPoints() : base("/auditSchedule")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {

            app.MapPost("/", async ([FromBody] AuditScheduleDto auditScheduleDto, IAuditScheduleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
               
                if (auditScheduleDto.AuditSchduleDetails == null || !auditScheduleDto.AuditSchduleDetails.Any())
                {
                    return Results.BadRequest("No audit schedule details provided.");
                }

                // Validate overlapping audits
                var overlapErrors = await service.GetOverlappingAuditAsync(auditScheduleDto, cancellationToken);
                if (overlapErrors.Count > 0)
                {
                    return Results.BadRequest(new { Errors = overlapErrors });
                }

                // Save audit schedule
                var createdAuditSchedule = await service.SaveOrUpdateAsync(auditScheduleDto, cancellationToken).ConfigureAwait(false);

                // Save auditable offices if provided
                if (auditScheduleDto.AuditableOffices?.Count > 0)
                {
                    var auditableOfficesList = auditScheduleDto.AuditableOffices.Select(officeId => new AuditableOfficesDto
                    {
                        AuditScheduleId = createdAuditSchedule.Id,
                        OfficeId = officeId.OfficeId
                    }).ToList();

                    await service.SaveAuditableOfficesAsync(auditableOfficesList, cancellationToken);
                }

                // Clear cache
                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);

                return Results.Created($"/auditSchedule/{createdAuditSchedule.Id}", createdAuditSchedule);
            })
            .WithTags(_AuditSchedule);

            app.MapGet("/", async (IAuditScheduleService service, CancellationToken cancellationToken) =>
            {
                var auditScheduleDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(auditScheduleDto);
            })
           .WithTags(_AuditSchedule)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true);

            app.MapGet("/{id}", async (int id, IAuditScheduleService service, CancellationToken cancellationToken) =>
            {
                var auditScheduleDto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return auditScheduleDto != null ? Results.Ok(auditScheduleDto) : Results.NotFound();
            })
           .WithTags(_AuditSchedule)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_AuditSchedule), true);
        }
    }
}
