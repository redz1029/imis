using Base.Auths.Permissions;

namespace IMIS.Application.PgsPermissionSettings
{
    public class PGSReportPermission : BaseOperationPermission
    {
        public override string ModuleName => "PGSReportSetting";
        public override string PermissionGroup => PermissionGrouper.Report;
    }
}
