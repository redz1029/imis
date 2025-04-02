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
        private const string _AuditSchedule = "Create AuditSchedule";
        public AuditScheduleEndPoints() : base("/AuditSchedule")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] AuditScheduleDto auditScheduleDto, 
                                    IAuditScheduleService service, 
                                    IAuditScheduleRepository auditRepository, // Added repository for validation
                                    IOutputCacheStore cache, 
                                    CancellationToken cancellationToken) =>
            {
                
                //  Check for overlapping audits before saving
                foreach (var office in auditScheduleDto.AuditSchduleDetails!)
                {
                    var overlappingSchedule = await auditRepository
                        .GetOverlappingAuditAsync(office.OfficeId, auditScheduleDto.StartDate, auditScheduleDto.EndDate, auditScheduleDto.Id);

                    if (overlappingSchedule != null)
                    {
                        return Results.BadRequest($"Office ID {office.OfficeId} is already scheduled for an audit during this period.");
                    }
                }
                //  Save the audit schedule
                var createdAuditSchedule = await service.SaveOrUpdateAsync(auditScheduleDto, cancellationToken).ConfigureAwait(false);

                //  Save auditable offices if present
                if (auditScheduleDto.AuditableOffices != null && auditScheduleDto.AuditableOffices.Count > 0)
                {
                    List<AuditableOfficesDto> auditableOfficesList = new();
                    foreach (var officeId in auditScheduleDto.AuditableOffices)
                    {
                        auditableOfficesList.Add(new AuditableOfficesDto
                        {
                            AuditScheduleId = createdAuditSchedule.Id,
                            OfficeId = officeId.OfficeId,  
                        });
                    }
                    await service.SaveAuditableOfficesAsync(auditableOfficesList, cancellationToken);
                }

                //  Clear cache
                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);
                return Results.Created($"/AuditSchedule/{createdAuditSchedule.Id}", createdAuditSchedule);
            })
            .WithTags(_AuditSchedule);
        }
    }
}
