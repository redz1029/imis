using Base.Primitives;

namespace IMIS.Domain
{
    public enum OrganizationImprovementType
    {
        PGS = 2, // Performance Governance System
        ISO = 1 // Internal Organization for Standardization
    }

    public class Auditor : Entity<int>
    {
        public OrganizationImprovementType ImprovementType;

        public required bool IsActive { get; set; }
        public required string UserId { get; set; }
        public User? User { get; set; }

        public ICollection<AuditorOffices>? AuditorOffices { get; set; }
        public ICollection<AuditorTeams>? AuditorTeams { get; set; }

        

    }
   


}

