using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.AuditPlanModule;
using IMIS.Domain;

namespace IMIS.Application.AuditProgrammeModule
{
    public class AuditProgrammeDto : BaseDto<AuditProgramme, int>
    {
        // Added Year to match the Domain Entity
        public int Year { get; set; }
        public required string For { get; set; }
        public required string From { get; set; }
        public required string Purpose { get; set; }
        public required string ScopeAndFreqAudit { get; set; }
        public required string InternalAuditSched { get; set; }
        public required string AuditPlanObjective { get; set; }
        public required string ScopeOfAudit { get; set; }

        // Collection of nested DTOs
        public List<AuditProgrammeObjectiveDto> Objectives { get; set; } = new();
        public List<AuditPlanDto> AuditPlan { get; set; } = new();
        public AuditProgrammeDto() { }

        [SetsRequiredMembers]
        public AuditProgrammeDto(AuditProgramme entity)
        {
            Id = entity.Id;
            Year = entity.Year; // Mapping Year from Entity to DTO
            For = entity.For;
            From = entity.From;
            Purpose = entity.Purpose;
            ScopeAndFreqAudit = entity.ScopeAndFreqAudit;
            InternalAuditSched = entity.InternalAuditSched;
            AuditPlanObjective = entity.AuditPlanObjective;
            ScopeOfAudit = entity.ScopeOfAudit;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            // Map nested collection
            if (entity.Objectives != null)
            {
                Objectives = entity.Objectives
                    .OrderBy(o => o.SortOrder)
                    .Select(o => new AuditProgrammeObjectiveDto(o))
                    .ToList();
            }
        }

        public override AuditProgramme ToEntity()
        {
            return new AuditProgramme
            {
                Id = Id,
                Year = Year, // Mapping Year from DTO to Entity
                For = For,
                From = From,
                Purpose = Purpose,
                ScopeAndFreqAudit = ScopeAndFreqAudit,
                InternalAuditSched = InternalAuditSched,
                AuditPlanObjective = AuditPlanObjective,
                ScopeOfAudit = ScopeOfAudit,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion,

                // Map DTO collection back to Entity collection
                Objectives = Objectives.Select(o => o.ToEntity()).ToList()
            };
        }
    }
}