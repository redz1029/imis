using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditProgrammeObjective : Entity<int>
    {
        public required int SortOrder { get; set; }
        public required string Description { get; set; }

        // Foreign Key
        public required int AuditProgrammeId { get; set; }
        public AuditProgramme? AuditProgramme { get; set; }
    }
}