using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditPlanProcess : Entity<int>
    {
        public required string Name { get; set; }
        public string? Description { get; set; }
        public required bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastModifiedDate { get; set; }
    }
}