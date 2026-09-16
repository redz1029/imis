using System;
using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditProgrammeStatusHistoryModule
{
    public class AuditProgrammeStatusHistoryDto : BaseDto<AuditProgrammeStatusHistory, int>
    {
        public int AuditProgrammeId { get; set; }
        public int AuditStatusId { get; set; }
        public string? StatusCode { get; set; }
        public string? StatusName { get; set; }
        public DateTime ChangedDate { get; set; }
        public string? Remarks { get; set; }

        public AuditProgrammeStatusHistoryDto() { }

        [SetsRequiredMembers]
        public AuditProgrammeStatusHistoryDto(AuditProgrammeStatusHistory entity)
        {
            Id = entity.Id;
            AuditProgrammeId = entity.AuditProgrammeId;
            AuditStatusId = entity.AuditStatusId;
            StatusCode = entity.AuditStatus?.Code;
            StatusName = entity.AuditStatus?.Name;
            ChangedDate = entity.ChangedDate;
            Remarks = entity.Remarks;

            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditProgrammeStatusHistory ToEntity()
        {
            return new AuditProgrammeStatusHistory
            {
                Id = Id,
                AuditProgrammeId = AuditProgrammeId,
                AuditStatusId = AuditStatusId,
                ChangedDate = ChangedDate == default ? DateTime.UtcNow : ChangedDate,
                Remarks = Remarks,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}