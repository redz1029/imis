using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditStatusModule
{
    public class AuditPlanStatusDto : BaseDto<AuditPlanStatus, int>
    {
        public required string Code { get; set; }
        public required string Name { get; set; }
        public int SortOrder { get; set; }
        public required bool IsActive { get; set; }

        public AuditPlanStatusDto() { }

        [SetsRequiredMembers]
        public AuditPlanStatusDto(AuditPlanStatus auditStatus)
        {
            Id = auditStatus.Id;
            Code = auditStatus.Code;
            Name = auditStatus.Name;
            SortOrder = auditStatus.SortOrder;
            IsActive = auditStatus.IsActive;

            IsDeleted = auditStatus.IsDeleted;
            RowVersion = auditStatus.RowVersion;
        }

        public override AuditPlanStatus ToEntity()
        {
            return new AuditPlanStatus
            {
                Id = Id,
                Code = Code,
                Name = Name,
                SortOrder = SortOrder,
                IsActive = IsActive,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}