using Base.Auths.Permissions;

namespace IMIS.Application.AuditPlanApprovalModule
{
    public class AuditPlanApprovalPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditPlanApproval";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        // Additional specific permissions for audit plan approvals
        public const string CanApprove = "AuditPlanApproval.Approve";
        public const string CanReject = "AuditPlanApproval.Reject";
        public const string CanReview = "AuditPlanApproval.Review";
        public const string CanViewAll = "AuditPlanApproval.ViewAll";
        public const string CanViewOwn = "AuditPlanApproval.ViewOwn";
        public const string CanAddSignature = "AuditPlanApproval.AddSignature";
    }
}