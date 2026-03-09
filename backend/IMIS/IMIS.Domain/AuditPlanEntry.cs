using Base.Primitives;

namespace IMIS.Domain
{
   
    public class AuditPlanEntry : Entity<int>
    {
        public required int AuditPlanId { get; set; }
        public AuditPlan? AuditPlan { get; set; }
        
        public required int DayNumber { get; set; }
        public required DateTime Time { get; set; }
        public required int? OfficeId { get; set; }
        public Office? Office { get; set; } = null;
        public required Team? Team { get; set; }
        
        public List<AuditPlanPersonResponsible>? ResposiblePersons { get; set; }
        public List<User> Auditors { get; set; } = new();
        public List<IsoStandard> IsoStandards { get; set; } = new();

        public List<AuditPlanProcess> AuditPlanProcesses { get; set; } = new();

    }
}
