using Base.Auths.Permissions;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditPlan";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        // Additional specific permissions for audit plans
        public const string CanSubmitForApproval = "AuditPlan.SubmitForApproval";
        public const string CanApprove = "AuditPlan.Approve";
        public const string CanReject = "AuditPlan.Reject";
        public const string CanViewAll = "AuditPlan.ViewAll";
        public const string CanViewOwn = "AuditPlan.ViewOwn";
    }
}