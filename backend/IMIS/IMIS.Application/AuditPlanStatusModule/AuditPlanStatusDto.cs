using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanStatusModule
{
    public class AuditPlanStatusDTO : BaseDto<AuditPlanStatus, int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }

        public AuditPlanStatusDTO() { } 

        [SetsRequiredMembers]
        public AuditPlanStatusDTO(AuditPlanStatus auditPlanStatus)
        {
            this.Id = auditPlanStatus.Id;
            this.Name = auditPlanStatus.Name;
            this.IsActive = auditPlanStatus.IsActive;
        }

        public override AuditPlanStatus ToEntity()
        {
            return new AuditPlanStatus()
            {
                Id = Id,
                Name = Name,
                IsActive = IsActive
            };
        }
    }
}