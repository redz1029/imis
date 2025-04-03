using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public class PerfomanceGovernanceSystemDto : BaseDto<PerfomanceGovernanceSystem, long>
    {
        public required PgsPeriodDto PgsPeriod { get; set; }  
        public required OfficeDto Office { get; set; } 
        public string? Remarks { get; set; }
        public List<PGSDeliverableDto>? PgsDeliverables { get; set; }
        public PgsReadinessRatingDto? PgsReadinessRating { get; set; }
        public PerfomanceGovernanceSystemDto() { }
        [SetsRequiredMembers]
        public PerfomanceGovernanceSystemDto(PerfomanceGovernanceSystem perfomanceGovernanceSystem)
        {
            this.Id = perfomanceGovernanceSystem.Id;
            this.Remarks = perfomanceGovernanceSystem.Remarks;
            this.PgsPeriod = perfomanceGovernanceSystem.PgsPeriod != null ? new PgsPeriodDto(perfomanceGovernanceSystem.PgsPeriod) : null;
            this.Office = perfomanceGovernanceSystem.Office != null ? new OfficeDto(perfomanceGovernanceSystem.Office) : null;
            this.PgsReadinessRating = perfomanceGovernanceSystem.PgsReadinessRating != null ? new PgsReadinessRatingDto(perfomanceGovernanceSystem.PgsReadinessRating) : null;
            this.PgsDeliverables = perfomanceGovernanceSystem.PgsDeliverables?.Select(d => new PGSDeliverableDto(d)).ToList();

        }
        public override PerfomanceGovernanceSystem ToEntity()
        {
            return new PerfomanceGovernanceSystem()
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


