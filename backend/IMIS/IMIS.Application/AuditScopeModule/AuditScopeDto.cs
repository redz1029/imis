using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditScopeModule
{
    public class AuditScopeDto : BaseDto<AuditScope, int>
    {
        public required string Auditee { get; set; }
        public int? TeamId { get; set; }

        // FIX: AuditScope.AuditReportId is required on the entity —
        // ToEntity() must set it, and previously didn't.
        public required int AuditReportId { get; set; }

        public AuditScopeDto() { }

        [SetsRequiredMembers]
        public AuditScopeDto(AuditScope entity)
        {
            Id = entity.Id;
            Auditee = entity.Auditee;
            TeamId = entity.TeamId;
            AuditReportId = entity.AuditReportId;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditScope ToEntity()
        {
            return new AuditScope
            {
                Id = Id,
                Auditee = Auditee,
                TeamId = TeamId,
                AuditReportId = AuditReportId,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
                // Note: AuditProcessAudited is still attached/managed at the
                // service/repository layer, per the original design — no
                // AuditScopeService/Repository has been shown to me yet.
            };
        }
    }
}