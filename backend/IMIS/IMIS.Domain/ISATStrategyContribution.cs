using Base.Primitives;

namespace IMIS.Domain
{
    public class ISATStrategyContribution : Entity<long>
    {
        public long ISATId { get; set; }
        public long? PgsDeliverableId { get; set; }
        public PgsDeliverable? PgsDeliverable { get; set; }
        public DateTime? PostingDate { get; set; }
    }
}
