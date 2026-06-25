using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class PerformanceValidationTool : Entity<long>
    {
        public int PerformanceValidationToolPeriodId { get; set; }
        public PerformanceValidationToolPeriod? PerformanceValidationToolPeriod { get; set; }
        public List<PerformanceValidationToolValidators>? Validators { get; set; }
        public int? OfficeId { get; set; }
        public Office? Office { get; set; }
        public required string OfficeHeadUserId { get; set; }
        public User? OfficeHeadUser { get; set; }
        public DateTime? ValidateDate { get; set; }
        public PerformanceValidationToolObjectives? Objectives { get; set; }
        public List<PerformanceValidationToolDeliverableFindings>? DeliverableFindings { get; set; }
        public string? Comment { get; set; }
        public DateTime? PostingDate { get; set; }
        public PerformanceValidationToolConclusion? Conclusion { get; set; }
        public virtual ICollection<PerformanceValidationToolSignatory>? PvtSignatories { get; set; }

        public long? PerformanceGovernanceSystemId { get; set; }
        [ForeignKey(nameof(PerformanceGovernanceSystemId))]
        public virtual PerfomanceGovernanceSystem? PerformanceGovernanceSystem { get; set; }

    }
}
