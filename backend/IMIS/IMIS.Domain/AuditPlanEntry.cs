using Base.Primitives;

namespace IMIS.Domain
{
    public enum AuditTypeToggle
    {
        Office = 0,
        Process = 1
    }

    public enum ResponsibilityToggle
    {
        Team = 0,
        Person = 1
    }

    public class AuditPlanEntry : Entity<long>
    {
        // Foreign key to AuditPlanHeader
        public required long AuditPlanHeaderId { get; set; }
        public AuditPlanHeader? AuditPlanHeader { get; set; }
        
        // Day number (e.g., Day 1, Day 2)
        public required int DayNumber { get; set; }
        
        // Time for the audit
        public required TimeSpan Time { get; set; }
        
        // Type toggle: Office or Process
        public required AuditTypeToggle Type { get; set; }
        
        // Reference ID (Office ID or Process ID depending on Type)
        public required long ReferenceId { get; set; }
        
        // Responsibility toggle: Team or Person
        public required ResponsibilityToggle Responsibility { get; set; }
        
        // Responsible ID (Team ID or Auditor ID depending on Responsibility)
        public required long ResponsibleId { get; set; }
        public User? ResponsiblePerson { get; set; }
        public Team? ResponsibleTeam { get; set; }
        
        // Navigation: Many-to-many with ISO Standards through AuditPlanEntryStandard
        public List<AuditPlanEntryStandard>? Standards { get; set; }
    }
}
