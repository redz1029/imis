using Base.Primitives;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;
using System.Text.Json.Serialization;

namespace IMIS.Application.AuditPlanApprovalModule
{
    public class AuditPlanApprovalDto : BaseDto<AuditPlanApproval, int>
    {

        [JsonPropertyName("auditPlanId")]
        public int? AuditPlanId { get; set; }

        [JsonPropertyName("auditProgrammeId")]
        public int? AuditProgrammeId { get; set; }

        [JsonPropertyName("aproverId")]
        public required string ApproverId { get; set; }

        [JsonPropertyName("approverName")]
        public string? ApproverName { get; set; }

        [JsonPropertyName("action")]
        public string? Action { get; set; }

        [JsonPropertyName("timestamp")]
        public DateTime Timestamp { get; set; }

        [JsonPropertyName("comments")]
        public string? Comments { get; set; }

        public AuditPlanApprovalDto() { }

        [SetsRequiredMembers]
        public AuditPlanApprovalDto(AuditPlanApproval approval)
        {
            Id = approval.Id;
            AuditPlanId = approval.AuditPlanId;
            AuditProgrammeId = approval.AuditProgrammeId;
            ApproverId = approval.ApproverId;
            ApproverName = approval.Approver?.UserName;
            Action = approval.Action;
            Timestamp = approval.Timestamp;
            Comments = approval.Comments;
            IsDeleted = approval.IsDeleted;
            RowVersion = approval.RowVersion;
        }

        public override AuditPlanApproval ToEntity()
        {
            return new AuditPlanApproval
            {
                Id = Id,
                AuditPlanId = AuditPlanId,
                AuditProgrammeId = AuditProgrammeId,
                ApproverId = ApproverId,
                Action = Action,
                Timestamp = Timestamp,
                Comments = Comments,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}