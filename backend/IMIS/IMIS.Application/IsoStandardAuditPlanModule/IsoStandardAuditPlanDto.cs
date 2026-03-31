using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.IsoStandardAuditPlanModule // Adjusted namespace to match the entity context
{
    public class IsoStandardAuditPlanDto : BaseDto<IsoStandardAuditPlan, long>
    {
        public long IsoStandardId { get; set; }
        public int AuditPlanEntryId { get; set; }

        public IsoStandardAuditPlanDto() { }

        [SetsRequiredMembers]
        public IsoStandardAuditPlanDto(IsoStandardAuditPlan entity)
        {
            if (entity != null)
            {
                Id = entity.Id;
                // Using the null-coalescing operator since entity properties were nullable/required
                IsoStandardId = entity.IsoStandardId ?? 0;
                AuditPlanEntryId = entity.AuditPlanEntryId ?? 0;
            }
        }

        public override IsoStandardAuditPlan ToEntity()
        {
            return new IsoStandardAuditPlan()
            {
                Id = Id,
                IsoStandardId = IsoStandardId,
                AuditPlanEntryId = AuditPlanEntryId
            };
        }
    }
}