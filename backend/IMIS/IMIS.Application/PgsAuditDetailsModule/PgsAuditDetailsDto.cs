using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.PgsModule
{
    public class PgsAuditDetailsDto : BaseDto<PgsAuditDetails, long>
    {
        public required PgsPeriodDto PgsPeriod { get; set; }  
        public required OfficeDto Office { get; set; } 
        public string? Remarks { get; set; }
        public List<PGSDeliverableDto>? PgsDeliverables { get; set; }

        public override PgsAuditDetails ToEntity()
        {
            return new PgsAuditDetails()
            {
                Id = Id,
                PgsPeriod = PgsPeriod.ToEntity(),
                Office = Office.ToEntity(),
                Remarks = Remarks,
                PgsDeliverables = PgsDeliverables?.Select(d => d.ToEntity()).ToList()
            };
        }
    }
}


