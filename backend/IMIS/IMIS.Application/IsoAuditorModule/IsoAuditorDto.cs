using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.IsoAuditorModule
{
    public class IsoAuditorDto : BaseDto<IsoAuditor, int>
    {
        public int? TeamId { get; set; }
        public string? AuditorId { get; set; } = string.Empty;
        public int? AuditPlanEntryId { get; set; }

        public IsoAuditorDto() { }

        [SetsRequiredMembers]
        public IsoAuditorDto(IsoAuditor entity)
        {
            if (entity != null)
            {
                Id = entity.Id;
                TeamId = entity.TeamId;
                AuditorId = entity.AuditorId;
                AuditPlanEntryId = entity.AuditPlanEntryId;
            }
        }

        public override IsoAuditor ToEntity()
        {
            return new IsoAuditor()
            {
                Id = Id,
                TeamId = TeamId,
                AuditorId = AuditorId,
                AuditPlanEntryId = AuditPlanEntryId
            };
        }
    }
}