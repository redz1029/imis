    using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsSummaryNarrative : Entity<int>
    {
        public string? Findings { get; set; }
        public string? Recommendation { get; set; }
        public string? Conclusion { get; set; }
        public int? PgsPeriodId { get; set; }
        public PgsPeriod? PgsPeriod { get; set; }
        public int? OfficeId { get; set; }
        public Office? Office { get; set; }

    }
}
