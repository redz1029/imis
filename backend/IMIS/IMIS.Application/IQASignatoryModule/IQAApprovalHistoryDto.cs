using Base.Primitives;
using IMIS.Domain;
using System;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace IMIS.Application.IQASignatoryModule
{
    public class IQAApprovalHistoryDto : BaseDto<IQAApprovalHistory, long>
    {
        public required string AuditEntityType { get; set; }
        public required int AuditEntityId { get; set; }
        public int? AuditProgrammeId { get; set; }
        public int? AuditPlanId { get; set; }
        public int? AuditScheduleId { get; set; }

        public required string Action { get; set; }
        public required string Status { get; set; }
        // Nullable: system-initiated history rows carry no user (FK-safe).
        public string? UserId { get; set; }
        public string? UserName { get; set; }
        public string? UserFullName { get; set; }
        public DateTime ActionDate { get; set; }
        public string? Comments { get; set; }
        public string? OfficeName { get; set; }
        public string? RoleOrPosition { get; set; }

        public IQAApprovalHistoryDto() { }

        [SetsRequiredMembers]
        public IQAApprovalHistoryDto(IQAApprovalHistory entity)
        {
            Id = entity.Id;
            AuditEntityType = entity.AuditEntityType;
            AuditEntityId = entity.AuditEntityId;
            AuditProgrammeId = entity.AuditProgrammeId;
            AuditPlanId = entity.AuditPlanId;
            AuditScheduleId = entity.AuditScheduleId;
            Action = entity.Action;
            Status = entity.Status;
            UserId = entity.UserId;
            UserName = entity.User?.UserName;
            UserFullName = FormatFullName(entity.User);
            ActionDate = entity.ActionDate;
            Comments = entity.Comments;
            OfficeName = entity.OfficeName;
            RoleOrPosition = entity.RoleOrPosition;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        private static string? FormatFullName(User? user)
        {
            if (user == null) return null;
            var parts = new[] { user.Prefix, user.FirstName, user.MiddleName, user.LastName, user.Suffix }
                .Where(p => !string.IsNullOrWhiteSpace(p));
            var full = string.Join(" ", parts);
            return string.IsNullOrWhiteSpace(full) ? user.UserName : full;
        }

        public override IQAApprovalHistory ToEntity()
        {
            return new IQAApprovalHistory
            {
                Id = Id,
                AuditEntityType = AuditEntityType,
                AuditEntityId = AuditEntityId,
                AuditProgrammeId = AuditProgrammeId,
                AuditPlanId = AuditPlanId,
                AuditScheduleId = AuditScheduleId,
                Action = Action,
                Status = Status,
                UserId = UserId,
                ActionDate = ActionDate,
                Comments = Comments,
                OfficeName = OfficeName,
                RoleOrPosition = RoleOrPosition,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }

    public class RejectionDetailsDto
    {
        public string? RejectedBy { get; set; }
        public string? RejectedByUserId { get; set; }
        public DateTime? RejectedDate { get; set; }
        public string? RejectionReason { get; set; }
        public string? OfficeName { get; set; }
        public string? RoleOrPosition { get; set; }
    }
}
