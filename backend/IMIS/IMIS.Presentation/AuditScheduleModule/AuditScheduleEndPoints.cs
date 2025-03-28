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
            app.MapPost("/", async ([FromBody] AuditScheduleDto auditScheduleDto, IAuditScheduleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (auditScheduleDto == null)
                {
                    return Results.BadRequest("Audit Schedule data is required.");
                }

                var createdAuditSchedule = await service.SaveOrUpdateAsync(auditScheduleDto, cancellationToken).ConfigureAwait(false);

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
                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);
                return Results.Created($"/AuditSchedule/{createdAuditSchedule.Id}", createdAuditSchedule);
            })
            .WithTags(_AuditSchedule);
        }
    }
}
