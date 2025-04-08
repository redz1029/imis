using Carter;
using IMIS.Application.AuditableOfficesModule;
using IMIS.Application.AuditScheduleModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;

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
        }
    }
}
