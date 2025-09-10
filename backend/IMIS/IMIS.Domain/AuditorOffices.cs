using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditorOffices : Entity<int>
    {
        public int AuditorId { get; set; }
        public Auditor? Auditor { get; set; }
        public int OfficeId { get; set; }
        public Office? Office { get; set; }
        public int PgsPeriodId { get; set; }
        public PgsPeriod? PgsPeriod { get; set; }
        public bool IsOfficeHead { get; set; }
    }
}
