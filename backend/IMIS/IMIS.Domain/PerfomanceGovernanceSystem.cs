using Base.Primitives;

namespace IMIS.Domain
{
    public class PerfomanceGovernanceSystem : Entity<long>
    {
        public required PgsPeriod PgsPeriod { get; set; }
        public required Office Office { get; set; }
        public string? Remarks { get; set; }
        public List<PgsDeliverable>? PgsDeliverables { get; set; }
        public PgsReadinessRating? PgsReadinessRating { get; set; }  

    }
}
