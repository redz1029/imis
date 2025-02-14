using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsAuditDetails : Entity<long>
    {
        public PgsPeriod? PgsPeriod { get; set; }
        public  required Office? Office { get; set; }
        public PgsStatus Status { get; set; }
        public required string Remarks { get; set; }
    }
}
