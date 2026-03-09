using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanPersonResponsibleModule
{
    public class AuditPlanPersonResponsibleDto : BaseDto<AuditPlanPersonResponsible, int>
    {
        public required string Name { get; set; }
        public string? Position { get; set; }
        public string? ContactInfo { get; set; }
        public required bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }

        public AuditPlanPersonResponsibleDto() { }

        [SetsRequiredMembers]
        public AuditPlanPersonResponsibleDto(AuditPlanPersonResponsible person)
        {
            Id = person.Id;
            Name = person.Name;
            Position = person.Position;
            ContactInfo = person.ContactInfo;
            IsActive = person.IsActive;
            CreatedDate = person.CreatedDate;
            IsDeleted = person.IsDeleted;
            RowVersion = person.RowVersion;
        }

        public override AuditPlanPersonResponsible ToEntity()
        {
            return new AuditPlanPersonResponsible
            {
                Id = Id,
                Name = Name,
                Position = Position,
                ContactInfo = ContactInfo,
                IsActive = IsActive,
                CreatedDate = CreatedDate,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}