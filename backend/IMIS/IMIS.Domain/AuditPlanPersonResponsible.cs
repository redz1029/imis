using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditPlanPersonResponsible : Entity<int>
    {
        public required string Name { get; set; }
        public string? Position { get; set; }
        public string? ContactInfo { get; set; }
        public required bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}