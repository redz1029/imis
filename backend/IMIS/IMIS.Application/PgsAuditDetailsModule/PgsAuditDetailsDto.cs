using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public class PgsAuditDetailsDto : BaseDto<PgsAuditDetails, long>
    {
        public required PgsPeriodDto PgsPeriod { get; set; }  
        public required OfficeDto Office { get; set; } 
        public string? Remarks { get; set; }
        public List<PGSDeliverableDto>? PgsDeliverables { get; set; }
        public PgsReadinessRatingDto? PgsReadinessRating { get; set; }
        public PgsAuditDetailsDto() { }
        [SetsRequiredMembers]
        public PgsAuditDetailsDto(PgsAuditDetails pgsAuditDetails)
        {
            this.Id = pgsAuditDetails.Id;
            this.Remarks = pgsAuditDetails.Remarks;
        }
        public override PgsAuditDetails ToEntity()
        {
            return new PgsAuditDetails()
            {
                Id = Id,
                PgsPeriod = PgsPeriod.ToEntity(),
                Office = Office.ToEntity(),
                Remarks = Remarks,
                PgsDeliverables = PgsDeliverables?.Select(d => d.ToEntity()).ToList(),
                PgsReadinessRating = PgsReadinessRating!.ToEntity()
            };
        }
       
    }
}


