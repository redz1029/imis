using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanProcessModule
{
    public class AuditPlanProcessDto : BaseDto<AuditPlanProcess, int>
    {
        public required string Name { get; set; }
        public string? Description { get; set; }
        public required bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }

        public AuditPlanProcessDto() { }
        
        [SetsRequiredMembers]
        public AuditPlanProcessDto(AuditPlanProcess process)
        {
            Id = process.Id;
            Name = process.Name;
            Description = process.Description;
            IsActive = process.IsActive;
            CreatedDate = process.CreatedDate;
            IsDeleted = process.IsDeleted;
            RowVersion = process.RowVersion;
        }

        public override AuditPlanProcess ToEntity()
        {
            return new AuditPlanProcess
            {
                Id = Id,
                Name = Name,
                Description = Description,
                IsActive = IsActive,
                CreatedDate = CreatedDate,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}