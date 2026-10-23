using Base.Auths.Permissions;

namespace IMIS.Application.NonconformingActionReportModule
{
    public class NonconformingActionReportPermission : BaseOperationPermission
    {
        public override string ModuleName => "NonconformingActionReport";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;
    }

    /// Workflow actions for a Nonconforming Action Report.
    public class NonconformingActionReportWorkflowPermission : BasePermission
    {
        public override string ModuleName => "NonconformingActionReportWorkflow";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        public string CanAcknowledge => "NonconformingActionReportAcknowledge";
        public string CanRespond => "NonconformingActionReportRespond";
        public string CanVerify => "NonconformingActionReportVerify";
        public string CanValidateAndClose => "NonconformingActionReportValidateAndClose";

        // Workflow statuses for the NCAR lifecycle.
        public const string StatusPendingVerification = "PENDING_VERIFICATION";
        public const string StatusActive = "ACTIVE";
        public const string StatusClosed = "CLOSED";
    }
}
