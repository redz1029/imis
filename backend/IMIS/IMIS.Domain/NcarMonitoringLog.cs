using Base.Primitives;

namespace IMIS.Domain
{
    public class NcarMonitoringLog : Entity<long>
    {
        public required string NcarNo { get; set; }
        public int IssuedYear { get; set; }
        public int SequenceNo { get; set; }

        public long? NonconformingActionReportId { get; set; }
        public NonconformingActionReport? NonconformingActionReport { get; set; }

        public required string DeptSectionUnit { get; set; }
        public DateTime DateIssued { get; set; }
        public required string IssuedByName { get; set; }

        public required string ItemNoRelevantStandard { get; set; }
        public required string AuditeeName { get; set; }

        public DateTime? DateVerified { get; set; }
        public string? VerifiedByAuditorName { get; set; }

        public DateTime? DateValidated { get; set; }

        public required string Remarks { get; set; } = "Active";
    }
}
