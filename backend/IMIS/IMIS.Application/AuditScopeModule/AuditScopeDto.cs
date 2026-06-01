using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditScopeModule
{
    public class AuditScopeDto : BaseDto<AuditScope, int>
    {
        public required string Auditee { get; set; }

        public AuditScopeDto() { }

        [SetsRequiredMembers]
        public AuditScopeDto(AuditScope entity)
        {
            Id = entity.Id;
            Auditee = entity.Auditee;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditScope ToEntity()
        {
            return new AuditScope
            {
                Id = Id,
                Auditee = Auditee,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
                // Note: Navigation properties (AuditProcessAudited, AuditorTeams) 
                // are attached/managed within the service/repository layer.
            };
        }
    }
}