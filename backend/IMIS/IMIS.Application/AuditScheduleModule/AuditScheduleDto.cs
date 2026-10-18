using Base.Primitives;
using IMIS.Application.IQASignatoryModule;
using IMIS.Domain;
using System;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditScheduleDto : BaseDto<AuditSchedule, int>
    {
        public required string Purpose { get; set; }
        public int? TeamId { get; set; }
        public required string Activity { get; set; }
        public required bool IsActive { get; set; }

        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public int AuditPlanId { get; set; }
        public required int AuditPlanEntryId { get; set; }

        // Read-only, derived from the IQA signatory rows. NEVER mapped in
        // ToEntity() — only SubmitAsync/DecideAsync change these.
        public string? StatusCode { get; set; }
        public string? StatusName { get; set; }

        // Live approval chain, in signing order.
        public List<IQASignatoryModule.IQASignatoryDto> Signatories { get; set; } = new();

        // Persistent approval, confirmation, and rejection history
        public List<IQASignatoryModule.IQAApprovalHistoryDto> ApprovalHistory { get; set; } = new();
        public IQASignatoryModule.RejectionDetailsDto? LatestRejection { get; set; }

        public string? OfficeName { get; set; }

        public AuditScheduleDto() { }

        [SetsRequiredMembers]
        public AuditScheduleDto(AuditSchedule entity)
        {
            this.Id = entity.Id;
            this.Purpose = entity.Purpose;
            this.TeamId = entity.TeamId;
            this.Activity = entity.Activity;
            this.IsActive = entity.IsActive;
            this.StartDate = entity.StartDate;
            this.EndDate = entity.EndDate;
            this.AuditPlanId = entity.AuditPlanId;
            this.AuditPlanEntryId = entity.AuditPlanEntryId;
            this.RowVersion = entity.RowVersion;

            if (entity.AuditableOffices != null && entity.AuditableOffices.Any())
            {
                this.OfficeName = entity.AuditableOffices.FirstOrDefault()?.Office?.Name;
            }

            // Callers must load IQASignatories (non-deleted) or this reads as Draft.
            var signatories = IQAApprovalWorkflow.Ordered(entity.IQASignatories);
            var stateCode = IQAApprovalWorkflow.DeriveStateCode(signatories, IQAApprovalWorkflow.EntityTypes.AuditSchedule);
            this.StatusCode = stateCode;
            this.StatusName = IQAApprovalWorkflow.StateName(stateCode, IQAApprovalWorkflow.EntityTypes.AuditSchedule);
            this.Signatories = signatories
                .Select(s => new IQASignatoryModule.IQASignatoryDto(s))
                .ToList();

            if (entity.ApprovalHistories != null && entity.ApprovalHistories.Any())
            {
                this.ApprovalHistory = entity.ApprovalHistories
                    .Where(h => !h.IsDeleted)
                    .OrderBy(h => h.ActionDate)
                    .Select(h => new IQASignatoryModule.IQAApprovalHistoryDto(h))
                    .ToList();

                var lastRej = entity.ApprovalHistories
                    .Where(h => !h.IsDeleted && (h.Action == IQAApprovalWorkflow.Actions.Rejected || h.Status == "Revision Required"))
                    .OrderByDescending(h => h.ActionDate)
                    .FirstOrDefault();

                if (lastRej != null)
                {
                    this.LatestRejection = new IQASignatoryModule.RejectionDetailsDto
                    {
                        RejectedBy = lastRej.User?.UserName,
                        RejectedByUserId = lastRej.UserId,
                        RejectedDate = lastRej.ActionDate,
                        RejectionReason = lastRej.Comments,
                        OfficeName = lastRej.OfficeName ?? this.OfficeName,
                        RoleOrPosition = lastRej.RoleOrPosition
                    };
                }
            }

            if (this.LatestRejection == null)
            {
                var rejectedSig = signatories.FirstOrDefault(s =>
                    s.ApprovalStatus == IQAApprovalWorkflow.Decisions.Rejected ||
                    s.ApprovalStatus == IQAApprovalWorkflow.Decisions.Disapproved);
                if (rejectedSig != null)
                {
                    this.LatestRejection = new IQASignatoryModule.RejectionDetailsDto
                    {
                        RejectedBy = rejectedSig.Signatory?.UserName,
                        RejectedByUserId = rejectedSig.SignatoryId,
                        RejectedDate = rejectedSig.DateSigned,
                        RejectionReason = rejectedSig.Remarks,
                        OfficeName = this.OfficeName,
                        RoleOrPosition = rejectedSig.IQASignatoryTemplate?.SignatoryLabel
                    };
                }
            }
        }

        public override AuditSchedule ToEntity()
        {
            return new AuditSchedule
            {
                Id = this.Id,
                Purpose = this.Purpose,
                TeamId = this.TeamId,
                Activity = this.Activity,
                IsActive = this.IsActive,
                StartDate = this.StartDate,
                EndDate = this.EndDate,
                AuditPlanId = this.AuditPlanId,
                AuditPlanEntryId = this.AuditPlanEntryId,
                RowVersion = this.RowVersion
            };
        }
    }
}