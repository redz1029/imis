using Base.Primitives;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.IQASignatoryTemplateModule
{
    public class IQASignatoryTemplateDto : BaseDto<IMIS.Domain.IQASignatoryTemplate, int>
    {
        public required string AuditEntityType { get; set; }
        public required string Status { get; set; }
        public required string SignatoryLabel { get; set; }
        public int OrderLevel { get; set; }
        public string? DefaultSignatoryId { get; set; }
        public string? DefaultSignatoryName { get; set; }
        public bool IsActive { get; set; }
        public int OfficeId { get; set; }
        public string? OfficeName { get; set; }
        public string? Position { get; set; }

        public IQASignatoryTemplateDto() { }

        [SetsRequiredMembers]
        public IQASignatoryTemplateDto(IMIS.Domain.IQASignatoryTemplate template)
        {
            Id = template.Id;
            AuditEntityType = template.AuditEntityType;
            Status = template.Status;
            SignatoryLabel = template.SignatoryLabel;
            OrderLevel = template.OrderLevel;
            DefaultSignatoryId = template.DefaultSignatoryId;
            DefaultSignatoryName = template.DefaultSignatory?.UserName;
            IsActive = template.IsActive;
            OfficeId = template.OfficeId;
            OfficeName = template.Office?.Name;
            Position = template.Position;
            IsDeleted = template.IsDeleted;
            RowVersion = template.RowVersion;
        }

        public override IMIS.Domain.IQASignatoryTemplate ToEntity()
        {
            return new IMIS.Domain.IQASignatoryTemplate
            {
                Id = Id,
                AuditEntityType = AuditEntityType,
                Status = Status,
                SignatoryLabel = SignatoryLabel,
                OrderLevel = OrderLevel,
                DefaultSignatoryId = DefaultSignatoryId,
                IsActive = IsActive,
                OfficeId = OfficeId,
                Position = Position,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}
