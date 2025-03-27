using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Carter;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.PgsKraModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.AuditScheduleDetailsModule
{
    public class AuditScheduleDetailsEndPoints : CarterModule
    {
      
        private const string _AuditScheduleDetails = "Create AuditScheduleDetails";
        public AuditScheduleDetailsEndPoints() : base("/AuditScheduleDetails")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {

            app.MapPost("/", async ([FromBody] AuditScheduleDetailDto AuditScheduleDetails, IAuditScheduleDetailService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (AuditScheduleDetails == null)
                {
                    return Results.BadRequest("Audit Schedule data is required.");
                }
                var createdAuditScheduleDetails = await service.SaveOrUpdateAsync(AuditScheduleDetails, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_AuditScheduleDetails, cancellationToken);
                return Results.Created($"/Audit Schedule/{AuditScheduleDetails.Id}", AuditScheduleDetails);
            })
          .WithTags(_AuditScheduleDetails);



        }


    }
}
