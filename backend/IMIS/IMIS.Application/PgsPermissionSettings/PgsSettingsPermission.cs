using Base.Auths.Permissions;

namespace IMIS.Application.PgsPermissionSettings
{
    public class PgsSettingsPermission : BaseOperationPermission
    {
        public override string ModuleName => "PgsSetting";
        public override string PermissionGroup => PermissionGrouper.Setting;

    }
}
