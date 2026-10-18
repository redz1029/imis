using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.IsoStandardAuditPlanModule // Adjusted namespace to match the entity context
{
    public class IsoStandardAuditPlanDto : BaseDto<IsoStandardAuditPlan, long>
    {
        public long IsoStandardId { get; set; }
        public int AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }

        /// <summary>
        /// The linked ISO standard (clause). Carried on the DTO so the clause
        /// reference travels with the Audit Plan Entry payload and the CRITERIA
        /// column can be rendered without a second master-list lookup.
        /// </summary>
        public IsoStandardDto? IsoStandard { get; set; }

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

                // Project the clause so it is available even when the caller
                // does not fetch the master ISO-standard list separately.
                if (entity.IsoStandard != null)
                {
                    IsoStandard = new IsoStandardDto(entity.IsoStandard);
                }
            }
        }

        public override IsoStandardAuditPlan ToEntity()
        {
            return new IsoStandardAuditPlan()
            {
                Id = Id,
                IsoStandardId = IsoStandardId,
                AuditPlanEntryId = AuditPlanEntryId,

                AuditPlanEntry = null
            };
        }
    }
}