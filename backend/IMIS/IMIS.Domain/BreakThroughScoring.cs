using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class BreakThroughScoring : Entity<int>
    {
        public required long PgsDeliverableId { get; set; }
        [ForeignKey(nameof(PgsDeliverableId))]
        public virtual PgsDeliverable? PgsDeliverable { get; set; }
        public double? PercentAccomplishment { get; set; }
        public double? Target { get; set; }
        public double? Strategic { get; set; }
        public double? BreakThrough { get; set; }
        public double? FinalScore { get; set; }
    }
}
