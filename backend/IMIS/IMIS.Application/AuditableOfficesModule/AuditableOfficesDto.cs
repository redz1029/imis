using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditableOfficesModule
{
    public class AuditableOfficesDto : BaseDto<AuditableOffices, int>
    {
        public required int AuditScheduleId { get; set; }
        public required int OfficeId { get; set; }

        public AuditableOfficesDto() { }

        [SetsRequiredMembers]
        public AuditableOfficesDto(AuditableOffices auditableOffices)
        {
            // Set base class properties
            Id = auditableOffices.Id;
            IsDeleted = auditableOffices.IsDeleted;
            RowVersion = auditableOffices.RowVersion;

            // Set specialized properties
            AuditScheduleId = auditableOffices.AuditScheduleId;
            OfficeId = auditableOffices.OfficeId;
        }

        public override AuditableOffices ToEntity()
        {
            return new AuditableOffices
            {
                // You MUST set the Id here to satisfy the 'required' constraint in EntityId<int>
                Id = Id,
                AuditScheduleId = AuditScheduleId,
                OfficeId = OfficeId,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}