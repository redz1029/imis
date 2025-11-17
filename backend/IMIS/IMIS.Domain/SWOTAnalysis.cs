using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class SWOTAnalysis : Entity<int>
    {
        public required string UserId { get; set; }
        [ForeignKey(nameof(UserId))]
        public virtual User? User { get; set; }
        public string? Strengths { get; set; }
        public string? Weaknesses { get; set; }
        public string? Opportunities { get; set; }
        public string? Threats { get; set; }
        public string? LongTermDepartmentStrategicPlan { get; set; }
        public string? ImmediateNeedsToAchieveVision { get; set; }
        public string? DepartmentAchievementsAndBestPractices { get; set; }
        public DateTime? PostingDate { get; set; }
    }
}
