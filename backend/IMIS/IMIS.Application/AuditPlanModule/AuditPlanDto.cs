using Base.Primitives;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.IQASignatoryModule;
using IMIS.Application.IsoAuditorModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text.Json.Serialization;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanDto : BaseDto<AuditPlan, int>
    {
        public required string PlanName { get; set; }
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }

        public int AuditProgrammeId { get; set; }

        [JsonIgnore]
        public AuditProgrammeDto? AuditProgramme { get; set; }

        public int? PreparerId { get; set; }
        public IsoAuditorDto? Preparer { get; set; }

        // Read-only, derived from the IQA signatory rows (DRAFT / PENDING /
        // APPROVED / DISAPPROVED). NEVER mapped in ToEntity() — the state only
        // changes through AuditPlanService.SubmitAsync / DecideAsync.
        public string? StatusCode { get; set; }
        public string? StatusName { get; set; }

        public DateTime CreatedDate { get; set; }
        public DateTime? LastModifiedDate { get; set; }

        public List<AuditPlanEntryDto> Entries { get; set; } = new();
        public List<AuditScheduleDto> AuditSchedules { get; set; } = new();

        // Live approval chain, in signing order.
        public List<IQASignatoryDto> Signatories { get; set; } = new();

        // Persistent approval & rejection history
        public List<IQAApprovalHistoryDto> ApprovalHistory { get; set; } = new();
        public RejectionDetailsDto? LatestRejection { get; set; }

        public AuditPlanDto() { }

        [SetsRequiredMembers]
        public AuditPlanDto(AuditPlan entity)
        {
            this.Id = entity.Id;
            this.PlanName = entity.PlanName;
            this.StartDate = entity.StartDate;
            this.EndDate = entity.EndDate;
            this.CreatedDate = entity.CreatedDate;
            this.LastModifiedDate = entity.LastModifiedDate;
            this.AuditProgrammeId = entity.AuditProgrammeId;

            this.Entries = entity.Entries != null
                ? entity.Entries.Select(x => new AuditPlanEntryDto(x)).ToList()
                : new List<AuditPlanEntryDto>();

            this.AuditSchedules = entity.AuditSchedules != null
                ? entity.AuditSchedules.Select(x => new AuditScheduleDto(x)).ToList()
                : new List<AuditScheduleDto>();

            // Check if any child schedule has been rejected or needs revision
            bool anyScheduleRevisionRequired = this.AuditSchedules.Any(s =>
                s.StatusCode == IQAApprovalWorkflow.StateCodes.RevisionRequired ||
                s.StatusCode == IQAApprovalWorkflow.StateCodes.Rejected ||
                s.StatusCode == IQAApprovalWorkflow.StateCodes.Disapproved);

            // Callers must load IQASignatories (non-deleted) or this reads as Draft.
            var signatories = IQAApprovalWorkflow.Ordered(entity.IQASignatories);
            var stateCode = IQAApprovalWorkflow.DeriveStateCode(signatories, IQAApprovalWorkflow.EntityTypes.AuditPlan, anyScheduleRevisionRequired);
            this.StatusCode = stateCode;
            this.StatusName = IQAApprovalWorkflow.StateName(stateCode, IQAApprovalWorkflow.EntityTypes.AuditPlan);
            this.Signatories = signatories.Select(s => new IQASignatoryDto(s)).ToList();

            if (entity.ApprovalHistories != null && entity.ApprovalHistories.Any())
            {
                this.ApprovalHistory = entity.ApprovalHistories
                    .Where(h => !h.IsDeleted)
                    .OrderBy(h => h.ActionDate)
                    .Select(h => new IQAApprovalHistoryDto(h))
                    .ToList();

                var lastRej = entity.ApprovalHistories
                    .Where(h => !h.IsDeleted && (h.Action == IQAApprovalWorkflow.Actions.Rejected || h.Status == "Revision Required"))
                    .OrderByDescending(h => h.ActionDate)
                    .FirstOrDefault();

                if (lastRej != null)
                {
                    this.LatestRejection = new RejectionDetailsDto
                    {
                        RejectedBy = FullNameOf(lastRej.User),
                        RejectedByUserId = lastRej.UserId,
                        RejectedDate = lastRej.ActionDate,
                        RejectionReason = lastRej.Comments,
                        OfficeName = lastRej.OfficeName,
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
                    this.LatestRejection = new RejectionDetailsDto
                    {
                        RejectedBy = FullNameOf(rejectedSig.Signatory),
                        RejectedByUserId = rejectedSig.SignatoryId,
                        RejectedDate = rejectedSig.DateSigned,
                        RejectionReason = rejectedSig.Remarks,
                        RoleOrPosition = rejectedSig.IQASignatoryTemplate?.SignatoryLabel
                    };
                }
                else if (anyScheduleRevisionRequired)
                {
                    // Surface the rejection from the rejected schedule
                    var rejectedSched = this.AuditSchedules.FirstOrDefault(s => s.LatestRejection != null);
                    if (rejectedSched?.LatestRejection != null)
                    {
                        this.LatestRejection = rejectedSched.LatestRejection;
                    }
                }
            }

            if (entity.Preparer != null)
            {
                this.Preparer = new IsoAuditorDto(entity.Preparer);
                this.PreparerId = entity.Preparer.Id;
            }
            else
            {
                this.Preparer = null;
                this.PreparerId = null;
            }

            this.RowVersion = entity.RowVersion;
        }

        private static string? FullNameOf(User? user)
        {
            if (user == null) return null;
            var parts = new[] { user.Prefix, user.FirstName, user.MiddleName, user.LastName, user.Suffix }
                .Where(p => !string.IsNullOrWhiteSpace(p));
            var full = string.Join(" ", parts);
            return string.IsNullOrWhiteSpace(full) ? user.UserName : full;
        }

        public override AuditPlan ToEntity()
        {
            return new AuditPlan
            {
                Id = this.Id,
                PlanName = this.PlanName,
                StartDate = this.StartDate,
                EndDate = this.EndDate,
                CreatedDate = this.CreatedDate,
                LastModifiedDate = this.LastModifiedDate,
                AuditProgrammeId = this.AuditProgrammeId,
                Preparer = this.Preparer?.ToEntity(),

                Entries = this.Entries?.Select(x => x.ToEntity()).ToList()
                                 ?? new List<AuditPlanEntry>(),
                AuditSchedules = this.AuditSchedules?.Select(x => x.ToEntity()).ToList()
                                 ?? new List<AuditSchedule>(),

                RowVersion = this.RowVersion
            };
        }
    }
}