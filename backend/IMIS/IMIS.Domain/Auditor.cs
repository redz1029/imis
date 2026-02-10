using Base.Primitives;

namespace IMIS.Domain
{
    public enum OrganizationImprovementType
    {
        PGS = 0, // Performance Governance System
        ISO = 1 // Internal Organization for Standardization
    }

    public class Auditor : Entity<int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
        public required string UserId { get; set; }
        public User? User { get; set; }

        public ICollection<AuditorOffices>? AuditorOffices { get; set; }
        public ICollection<AuditorTeams>? AuditorTeams { get; set; }

        // Tagging auditors with their improvement type
        public required OrganizationImprovementType ImprovementType { get; set; }
    }
   


}

