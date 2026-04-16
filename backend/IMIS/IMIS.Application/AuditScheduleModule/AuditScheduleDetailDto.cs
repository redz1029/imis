using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditScheduleDetailsDto : BaseDto<AuditScheduleDetails, int>
    {
        public required int AuditPlanEntryId { get; set; }
        public required int AuditScheduleId { get; set; }

        public AuditScheduleDetailsDto() { }

        [SetsRequiredMembers]
        public AuditScheduleDetailsDto(AuditScheduleDetails entity)
        {
            Id = entity.Id;
            AuditPlanEntryId = entity.AuditPlanEntryId;
            AuditScheduleId = entity.AuditScheduleId;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditScheduleDetails ToEntity()
        {
            return new AuditScheduleDetails
            {
                Id = Id,
                AuditPlanEntryId = AuditPlanEntryId,
                AuditScheduleId = AuditScheduleId,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}