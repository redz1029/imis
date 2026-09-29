using System;
using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.NcarMonitoringLogModule
{
    public class NcarMonitoringLogDto : BaseDto<NcarMonitoringLog, long>
    {
        public required string NcarNo { get; set; }
        public long? NonconformingActionReportId { get; set; }
        public required string DeptSectionUnit { get; set; }
        public DateTime DateIssued { get; set; }
        public required string IssuedByName { get; set; }
        public required string ItemNoRelevantStandard { get; set; }
        public required string AuditeeName { get; set; }
        public DateTime? DateVerified { get; set; }
        public string? VerifiedByAuditorName { get; set; }
        public DateTime? DateValidated { get; set; }
        public required string Remarks { get; set; }
        public bool IsOverdue { get; set; }

        public NcarMonitoringLogDto() { }

        [SetsRequiredMembers]
        public NcarMonitoringLogDto(NcarMonitoringLog entity)
        {
            Id = entity.Id;
            NcarNo = entity.NcarNo;
            NonconformingActionReportId = entity.NonconformingActionReportId;
            DeptSectionUnit = entity.DeptSectionUnit;
            DateIssued = entity.DateIssued;
            IssuedByName = entity.IssuedByName;
            ItemNoRelevantStandard = entity.ItemNoRelevantStandard;
            AuditeeName = entity.AuditeeName;
            DateVerified = entity.DateVerified;
            VerifiedByAuditorName = entity.VerifiedByAuditorName;
            DateValidated = entity.DateValidated;
            Remarks = entity.Remarks;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            IsOverdue = entity.Remarks == "Active" && (DateTime.UtcNow - entity.DateIssued).TotalDays > 5;
        }

        public override NcarMonitoringLog ToEntity()
        {
            return new NcarMonitoringLog
            {
                Id = Id,
                NcarNo = NcarNo,
                NonconformingActionReportId = NonconformingActionReportId,
                DeptSectionUnit = DeptSectionUnit,
                DateIssued = DateIssued,
                IssuedByName = IssuedByName,
                ItemNoRelevantStandard = ItemNoRelevantStandard,
                AuditeeName = AuditeeName,
                DateVerified = DateVerified,
                VerifiedByAuditorName = VerifiedByAuditorName,
                DateValidated = DateValidated,
                Remarks = Remarks,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}
