using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditSchedule : Entity<int>
    {     
        public required string Purpose { get; set; }
        public required AuditorTeams? AuditorTeams { get; set; }
        public required string AuditTitle { get; set; }
        public required bool IsActive { get; set; }
        public ICollection<AuditableOffices>? AuditableOffices { get; set; }
        public ICollection<AuditScheduleDetails>? AuditSchduleDetails { get; set; }
    }
}
