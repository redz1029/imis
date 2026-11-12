using Base.Primitives;



namespace IMIS.Domain
{
    public class AuditSummaryFIndings : Entity<int>
    {
        public required int No { get; set; }
        public IsoStandard? Criteria { get; set; }
        public required string Findings { get; set; }

        /// <summary>
        /// The audit checklist row this line was raised from (a non-conforming
        /// clause). Null for a line the auditor added by hand on the report.
        /// </summary>
        public int? AuditChecklistId { get; set; }

        /// <summary>
        /// The criteria as printed (the clause, e.g. 8.5.1). Typed on a manual
        /// line; copied from the checklist clause on a fetched one. Null only on
        /// lines saved before the report was editable.
        /// </summary>
        public string? CriteriaText { get; set; }

        /// <summary>Reference number of the NCAR raised for a fetched line.</summary>
        public string? NcarReferenceNumber { get; set; }

        public int? AuditNcarStatusId { get; set; }

        public AuditNcarStatus? NcarStatus { get; set; }
        public required int AuditReportId { get; set; }
        public AuditReport? AuditReport { get; set; }
    }
}
