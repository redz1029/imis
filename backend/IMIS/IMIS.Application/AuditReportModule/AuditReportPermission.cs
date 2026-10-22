using Base.Auths.Permissions;

namespace IMIS.Application.AuditReportModule
{
    public class AuditReportPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditReport";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;
    }

    /// Workflow actions for an Audit Report.
    public class AuditReportWorkflowPermission : BasePermission
    {
        public override string ModuleName => "AuditReportWorkflow";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        public string CanSubmit => "AuditReportSubmit";
        public string CanApprove => "AuditReportApprove";
        public string CanReject => "AuditReportReject";
        public string CanNote => "AuditReportNote";
    }
}
