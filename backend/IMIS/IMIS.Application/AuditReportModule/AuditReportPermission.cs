using Base.Auths.Permissions;

namespace IMIS.Application.AuditReportModule
{
    public class AuditReportPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditReport";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        public const string CanApprove = "AuditReport.Approve";
        public const string CanReject = "AuditReport.Reject";
    }
}
