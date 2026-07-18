using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class OperationReviewProtocol : Entity<long>
    {        
        public int? DepartmentId { get; set; }
        [ForeignKey(nameof(DepartmentId))]
        public virtual Office? Department { get; set; }

        public int? DivisionId { get; set; }
        [ForeignKey(nameof(DivisionId))]
        public virtual Office? Division { get; set; }

        [Required]
        public required string UserId { get; set; }

        [ForeignKey(nameof(UserId))]
        public virtual User? User { get; set; }

        public string? Deputy { get; set; }

        public string? Documenter { get; set; }

        public long? PerformanceGovernanceSystemId { get; set; }

        [ForeignKey(nameof(PerformanceGovernanceSystemId))]
        public virtual PerfomanceGovernanceSystem? PerformanceGovernanceSystem { get; set; }

        public string? Venue { get; set; }

        public string? ScoreboardLocation { get; set; }

        public string? ScoreboardOIC { get; set; }

        public string? ActionPlan { get; set; }

        public string? Form1 { get; set; }

        public string? Form2 { get; set; }

        public string? Form3 { get; set; }

        public string? FrequencySchedule { get; set; }

        public string? FrequencyUpdate { get; set; }

        public string? Frequency { get; set; }

        public string? MinutesAttachmentPath { get; set; }
        public DateTime PostingDate { get; set; }

        public bool? IsDraft { get; set; }
    }
}
