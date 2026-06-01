 using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditChecklist : Entity<int>
    {
        public required string AuditScope { get; set; }
        public required int conforming { get; set; }
        public required string FindingAndRemarks { get; set; }
        public required string ItemsAndQuestions { get; set; }
        public required string Auditees { get; set; }
        public required AuditChecklistQNA? QnA { get; set; }
        public AuditChecklistQNA? AuditChecklistQNA { get; set; }
        public Auditor? Auditor { get; set; }
    }
}
