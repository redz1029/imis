using Base.Auths.Permissions;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditPlan";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;
    }

    /// Workflow actions for an Audit Plan. Kept separate from
    /// <see cref="AuditPlanPermission"/> so that granting a role the generic
    /// "Add/View/Edit Audit Plan" permission does not implicitly grant it the
    /// right to approve, reject or note submissions.
    public class AuditPlanWorkflowPermission : BasePermission
    {
        public override string ModuleName => "AuditPlanWorkflow";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        public string CanSubmitForApproval => "AuditPlanSubmitForApproval";
        public string CanApprove => "AuditPlanApprove";
        public string CanReject => "AuditPlanReject";
        public string CanNote => "AuditPlanNote";
        public string CanViewAll => "AuditPlanViewAll";
        public string CanViewOwn => "AuditPlanViewOwn";
    }
}
