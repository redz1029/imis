using Base.Auths.Permissions;

namespace IMIS.Application.PgsPermissionSettings
{
    public class PgsAuditorReportPermission : BaseOperationPermission
    {
        public override string ModuleName => "PgsAuditorReportSetting";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
