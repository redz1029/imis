using Base.Primitives;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;
using System.Text.Json.Serialization;

namespace IMIS.Application.AuditPlanApprovalModule
{
    public class AuditPlanApprovalDto : BaseDto<AuditPlanApproval, int>
    {

        [JsonPropertyName("auditPlanId")]
        public int AuditPlanId { get; set; }

        // This force maps the backend parameter contract to bind successfully
        [JsonPropertyName("aproverId")]
        public required int AproverId { get; set; }

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
                ApproverId = AproverId,
                Action = Action,
                Timestamp = Timestamp,
                Comments = Comments,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}