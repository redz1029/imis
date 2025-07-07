using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Application.PgsSignatoryModule;
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
        public required double PercentDeliverables { get; set; }
        public string? PgsStatus { get; set; }
        public List<PgsSignatoryDto>? PgsSignatories { get; set; }
        public bool ForSignature { get; set; }

        public PerfomanceGovernanceSystemDto() { }
        [SetsRequiredMembers]
        public PerfomanceGovernanceSystemDto(PerfomanceGovernanceSystem perfomanceGovernanceSystem)
        {
            this.Id = perfomanceGovernanceSystem.Id;
            this.Remarks = perfomanceGovernanceSystem.Remarks;
            this.PercentDeliverables = perfomanceGovernanceSystem.PercentDeliverables;
            this.PgsStatus = perfomanceGovernanceSystem.PgsStatus;
            this.PgsPeriod =  new PgsPeriodDto(perfomanceGovernanceSystem.PgsPeriod);
            this.Office =  new OfficeDto(perfomanceGovernanceSystem.Office);
            this.PgsReadinessRating = perfomanceGovernanceSystem.PgsReadinessRating != null ? new PgsReadinessRatingDto(perfomanceGovernanceSystem.PgsReadinessRating) : null;
            this.PgsDeliverables = perfomanceGovernanceSystem.PgsDeliverables?.Select(d => new PGSDeliverableDto(d)).ToList();           
            this.PgsSignatories = perfomanceGovernanceSystem.PgsSignatories?.Select(s => new PgsSignatoryDto
                 {
                    Id = s.Id,
                    PgsId = s.PgsId,
                    PgsSignatoryTemplateId = s.PgsSignatoryTemplateId,
                    SignatoryId = s.SignatoryId,
                    DateSigned = s.DateSigned,
                 }).ToList();

            this.ForSignature = false;
            this.IsDeleted = perfomanceGovernanceSystem.IsDeleted;
            this.RowVersion = perfomanceGovernanceSystem.RowVersion;
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
                PgsReadinessRating = PgsReadinessRating?.ToEntity(),
                PercentDeliverables = PercentDeliverables,
                PgsStatus = PgsStatus,
                PgsSignatories = PgsSignatories?.Select(s => s.ToEntity()).ToList()
            };
        }
    }
}


