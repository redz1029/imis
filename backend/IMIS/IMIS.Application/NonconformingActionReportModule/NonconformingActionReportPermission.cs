using Base.Auths.Permissions;

namespace IMIS.Application.NonconformingActionReportModule
{
    public class NonconformingActionReportPermission : BaseOperationPermission
    {
        public override string ModuleName => "NonconformingActionReport";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        public const string CanAcknowledge = "NonconformingActionReport.Acknowledge";
        public const string CanRespond = "NonconformingActionReport.Respond";
        public const string CanVerify = "NonconformingActionReport.Verify";
        public const string CanValidateAndClose = "NonconformingActionReport.ValidateAndClose";
    }
}
