using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditComFindingsModule
{
    public class AuditComFindingsDto : BaseDto<AuditComFindings, int>
    {
        public required string CommendableFindings { get; set; }
        public int? AreasId { get; set; }

        // FIX: AuditComFindings.AuditReportId is required on the entity —
        // ToEntity() must set it, and previously didn't.
        public required int AuditReportId { get; set; }

        public AuditComFindingsDto() { }

        [SetsRequiredMembers]
        public AuditComFindingsDto(AuditComFindings entity)
        {
            Id = entity.Id;
            CommendableFindings = entity.CommendableFindings;
            AuditReportId = entity.AuditReportId;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            if (entity.Areas != null)
            {
                AreasId = entity.Areas.Id;
            }
        }

        public override AuditComFindings ToEntity()
        {
            return new AuditComFindings
            {
                Id = Id,
                CommendableFindings = CommendableFindings,
                Area = AreasId ?? 0, // Assuming Area is required and should default to 0 if AreasId is null
                AuditReportId = AuditReportId,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}