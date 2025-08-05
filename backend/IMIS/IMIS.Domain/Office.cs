using Base.Primitives;

namespace IMIS.Domain
{
    public class Office : Entity<int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }

        public int OfficeTypeId { get; set; }
        public OfficeType? OfficeType { get; set; }

        public int? ParentOfficeId { get; set; }
        public Office? ParentOffice { get; set; }

        public ICollection<AuditorOffices>? AuditorOffices { get; set; }
        public ICollection<AuditableOffices>? AuditableOffices { get; set; }
        public ICollection<UserOffices>? UserOffices { get; set; }

        public ICollection<PgsSignatoryTemplate>? SignatoryTemplates { get; set; }
    }
}
