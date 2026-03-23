using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditPlanEntry : Entity<int>
    {
        public required int AuditPlanId { get; set; }
        public AuditPlan? AuditPlan { get; set; }

        public required int DayNumber { get; set; }
        public required DateTime Time { get; set; }


        public ICollection<IsoAuditProcess>? IsoAuditProcesses { get; set; }

        public ICollection<AuditPlanPersonResponsible>? ResponsiblePersons { get; set; }

        public ICollection<IsoAuditor>? IsoAuditors { get; set; } 
        public ICollection<IsoStandardAuditPlan>? IsoStandardAuditPlans { get; set; }
        public ICollection<AuditPlanProcess>? AuditPlanProcesses { get; set; } 


    }
}