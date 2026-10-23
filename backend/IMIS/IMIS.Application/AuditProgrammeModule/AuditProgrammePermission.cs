using Base.Auths.Permissions;

namespace IMIS.Application.AuditProgrammeModule
{
    public class AuditProgrammePermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditProgramme";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;
    }

    /// Workflow actions for an Audit Programme. Kept separate from
    /// <see cref="AuditProgrammePermission"/> so that granting a role the
    /// generic "Add/View/Edit Audit Programme" permission does not implicitly
    /// grant it the right to approve, reject or note submissions.
    public class AuditProgrammeWorkflowPermission : BasePermission
    {
        public override string ModuleName => "AuditProgrammeWorkflow";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        public string CanSubmitForApproval => "AuditProgrammeSubmitForApproval";
        public string CanNote => "AuditProgrammeNote";
        public string CanApprove => "AuditProgrammeApprove";
        public string CanReject => "AuditProgrammeReject";
        public string CanViewAll => "AuditProgrammeViewAll";
    }
}
