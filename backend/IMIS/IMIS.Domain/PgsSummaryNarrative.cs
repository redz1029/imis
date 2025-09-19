using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsSummaryNarrative : Entity<int>
    {
        public required string Findings { get; set; }
        public required string Recommendation { get; set; }
        public required string Conclusion { get; set; }
        public int? PgsPeriodId { get; set; }
        public PgsPeriod? PgsPeriod { get; set; }

    }
}
