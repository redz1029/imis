using System;
using System.Collections.Generic;
using System.Linq;
using Base.Primitives;


namespace IMIS.Domain
{
    public class AuditReport : Entity<int>
    {
        public required string AuditPurpose { get; set; }
        public required string AuditConclisions { get; set; }
        public AuditPlanProcess? OfficeAudited { get; set; }
        public IsoStandard? AuditStandardISO { get; set; }
        public AuditPlan? DateofAudit { get; set; }
        

        public ICollection<AuditComFindings>? AuditComFindings { get; set; }
        public ICollection<AuditScope>? AuditScope { get; set; }
        public ICollection<AuditSummaryFIndings>? AuditSummaryFIndings { get; set; }


    }
}
