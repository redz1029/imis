using Carter;
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

            app.MapPost("/", async ([FromBody] AuditScheduleDto AuditSchedule, IAuditScheduleService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (AuditSchedule == null)
                {
                    return Results.BadRequest("Audit Schedule data is required.");
                }
                var createdAuditSchedule = await service.SaveOrUpdateAsync(AuditSchedule, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditSchedule, cancellationToken);
                return Results.Created($"/Audit Schedule/{AuditSchedule.Id}", AuditSchedule);
            })
          .WithTags(_AuditSchedule);



        }


    }
}
