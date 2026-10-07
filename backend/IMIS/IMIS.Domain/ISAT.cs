using Base.Primitives;

namespace IMIS.Domain
{
    public class ISAT : Entity<long>
    {

        public int ISATPeriodId { get; set; }
        public PgsPeriod? ISATPeriod { get; set; }
        public required string EmployeeUserId { get; set; }
        public User? EmployeeUser { get; set; }

        public int? OfficeId { get; set; }
        public Office? Office { get; set; }

        public required string ImmediateSupervisorUserId { get; set; }
        public User? ImmediateSupervisorUser { get; set; }

        public string? Position { get; set; }

        public int? ServiceId { get; set; }
        public Office? Service { get; set; }

        public List<ISATAnnualPerformanceCommitments>? ISATAnnualPerformanceCommitments { get; set; }
        public List<ISATSignatory>? ISATSignatories { get; set; }

        public DateTime? PostingDate { get; set; }

    }
}
