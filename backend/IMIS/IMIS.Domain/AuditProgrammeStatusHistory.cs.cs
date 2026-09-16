using Base.Primitives;
using System;

namespace IMIS.Domain
{
    
    public class AuditProgrammeStatusHistory : Entity<int>
    {
        public int AuditProgrammeId { get; set; }
        public AuditProgramme? AuditProgramme { get; set; }

        public int AuditStatusId { get; set; }
        public AuditPlanStatus? AuditStatus { get; set; }

        public DateTime ChangedDate { get; set; } = DateTime.UtcNow;
        public string? Remarks { get; set; }
    }
}