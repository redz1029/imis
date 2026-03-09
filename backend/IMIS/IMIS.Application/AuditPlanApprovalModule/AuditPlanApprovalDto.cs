using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanApprovalModule
{
    public class AuditPlanApprovalDto : BaseDto<AuditPlanApproval, int>
    {
        public required int AuditPlanId { get; set; }
        public required int ApproverId { get; set; }
        public required string Action { get; set; }
        public required DateTime Timestamp { get; set; } 
        public string? Comments { get; set; }

        public AuditPlanApprovalDto() { }
        
        [SetsRequiredMembers]
        public AuditPlanApprovalDto(AuditPlanApproval approval)
        {
            Id = approval.Id;
            AuditPlanId = approval.AuditPlanId;
            ApproverId = approval.ApproverId;
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