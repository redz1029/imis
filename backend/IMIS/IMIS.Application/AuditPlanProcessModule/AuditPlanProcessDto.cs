using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanProcessModule
{
    public class AuditPlanProcessDto : BaseDto<AuditPlanProcess, int>
    {
        public int OfficeId { get; set; }
        public int AuditPlanEntryId { get; set; }

        public AuditPlanProcessDto() { }

        [SetsRequiredMembers]
        public AuditPlanProcessDto(AuditPlanProcess entity)
        {
            if (entity != null)
            {
                Id = entity.Id;
                OfficeId = entity.OfficeId;
                AuditPlanEntryId = entity.AuditPlanEntryId;
            }
        }

        public override AuditPlanProcess ToEntity()
        {
            return new AuditPlanProcess()
            {
                Id = Id,
                OfficeId = OfficeId,
                AuditPlanEntryId = AuditPlanEntryId
            };
        }
    }
}