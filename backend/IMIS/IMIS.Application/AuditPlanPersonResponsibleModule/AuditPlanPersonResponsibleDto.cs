using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanPersonResponsibleModule
{
    public class AuditPlanPersonResponsibleDto : BaseDto<AuditPlanPersonResponsible, int>
    {
        public string Name { get; set; } = string.Empty;

        // Made nullable so System.Text.Json doesn't crash on null incoming values
        public int? AuditPlanEntryId { get; set; }

        public AuditPlanEntry? AuditPlanEntry { get; set; }

        public AuditPlanPersonResponsibleDto() { }

        [SetsRequiredMembers]
        public AuditPlanPersonResponsibleDto(AuditPlanPersonResponsible entity)
        {
            if (entity != null)
            {
                Id = entity.Id;
                Name = entity.Name;
                AuditPlanEntryId = entity.AuditPlanEntryId;
            }
        }

        public override AuditPlanPersonResponsible ToEntity()
        {
            return new AuditPlanPersonResponsible()
            {
                Id = Id,
                Name = Name,
                // Fallbacks to 0 if null so the domain entity receives a valid integer
                AuditPlanEntryId = AuditPlanEntryId ?? 0,

                AuditPlanEntry = null
            };
        }
    }
}