using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditSummaryFindingsModule
{
    public class AuditSummaryFindingsDto : BaseDto<AuditSummaryFIndings, int>
    {
        public required int No { get; set; }
        public required string Findings { get; set; }
        public int? AuditNcarStatusId { get; set; }

        /// <summary>Set on a line fetched from the audit checklist; null on a manual one.</summary>
        public int? AuditChecklistId { get; set; }
        public string? CriteriaText { get; set; }
        public string? NcarReferenceNumber { get; set; }

        // FIX: AuditSummaryFIndings.AuditReportId is required on the
        // entity — ToEntity() must set it, and previously didn't.
        public required int AuditReportId { get; set; }

        public AuditSummaryFindingsDto() { }

        [SetsRequiredMembers]
        public AuditSummaryFindingsDto(AuditSummaryFIndings entity)
        {
            Id = entity.Id;
            No = entity.No;
            Findings = entity.Findings;
            AuditNcarStatusId = entity.AuditNcarStatusId;
            AuditChecklistId = entity.AuditChecklistId;
            CriteriaText = entity.CriteriaText;
            NcarReferenceNumber = entity.NcarReferenceNumber;
            AuditReportId = entity.AuditReportId;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditSummaryFIndings ToEntity()
        {
            return new AuditSummaryFIndings
            {
                Id = Id,
                No = No,
                Findings = Findings,
                AuditNcarStatusId = AuditNcarStatusId,
                AuditChecklistId = AuditChecklistId,
                CriteriaText = CriteriaText,
                NcarReferenceNumber = NcarReferenceNumber,
                AuditReportId = AuditReportId,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
                // Note: Criteria (IsoStandard) is still attached/managed at
                // the service/repository layer, per the original design.
            };
        }
    }
}