using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditComFindingsModule
{
    public class AuditComFindingsDto : BaseDto<AuditComFindings, int>
    {
        public required string CommendableFindings { get; set; }
        public required string Area { get; set; }

        public AuditComFindingsDto() { }

        [SetsRequiredMembers]
        public AuditComFindingsDto(AuditComFindings entity)
        {
            Id = entity.Id;
            CommendableFindings = entity.CommendableFindings;
            Area = entity.Area;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditComFindings ToEntity()
        {
            return new AuditComFindings
            {
                Id = Id,
                CommendableFindings = CommendableFindings,
                Area = Area,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}