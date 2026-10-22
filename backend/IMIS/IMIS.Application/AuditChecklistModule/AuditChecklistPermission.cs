using Base.Auths.Permissions;

namespace IMIS.Application.AuditChecklistModule
{
    public class AuditChecklistPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditChecklist";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;
    }

    /// Workflow actions for an Audit Checklist.
    public class AuditChecklistWorkflowPermission : BasePermission
    {
        public override string ModuleName => "AuditChecklistWorkflow";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        public string CanSubmit => "AuditChecklistSubmit";
        public string CanNote => "AuditChecklistNote";
    }
}
