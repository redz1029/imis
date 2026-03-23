using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.IsoAuditProcessModule
{
    public class IsoAuditProcessDto : BaseDto<IsoAuditProcess, int>
    {
        public string Name { get; set; } = string.Empty;
        public bool IsActive { get; set; }
        public int AuditPlanEntryId { get; set; }

        public IsoAuditProcessDto() { }

        [SetsRequiredMembers]
        public IsoAuditProcessDto(IsoAuditProcess entity)
        {
            if (entity != null)
            {
                Id = entity.Id;
                Name = entity.Name;
                IsActive = entity.IsActive;
                AuditPlanEntryId = entity.AuditPlanEntryId;
            }
        }

        public override IsoAuditProcess ToEntity()
        {
            return new IsoAuditProcess()
            {
                Id = Id,
                Name = Name,
                IsActive = IsActive,
                AuditPlanEntryId = AuditPlanEntryId
            };
        }
    }
}