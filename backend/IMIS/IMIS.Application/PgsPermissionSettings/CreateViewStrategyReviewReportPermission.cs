using Base.Auths.Permissions;

namespace IMIS.Application.PgsPermissionSettings
{
    public class CreateViewStrategyReviewReportPermission : BaseOperationPermission
    {
        public override string ModuleName => "CreateViewStrategyReviewReportSetting";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
