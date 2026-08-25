using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanProcessModule
{
    public class AuditPlanProcessDto : BaseDto<AuditPlanProcess, int>
    {
        public int? OfficeId { get; set; }
        public string? ProcessName { get; set; }
        public int AuditPlanEntryId { get; set; }

        public AuditPlanEntryDto? AuditPlanEntry { get; set; }

        public AuditPlanProcessDto() { }

        [SetsRequiredMembers]
        public AuditPlanProcessDto(AuditPlanProcess entity)
        {
            if (entity != null)
            {
                Id = entity.Id;
                OfficeId = entity.OfficeId;
                ProcessName = entity.ProcessName;
                AuditPlanEntryId = entity.AuditPlanEntryId;
            }
        }

        public override AuditPlanProcess ToEntity()
        {
            return new AuditPlanProcess()
            {
                Id = Id,
                OfficeId = OfficeId,
                ProcessName = ProcessName,
                AuditPlanEntryId = AuditPlanEntryId,

                AuditPlanEntry = null
            };
        }
    }
}