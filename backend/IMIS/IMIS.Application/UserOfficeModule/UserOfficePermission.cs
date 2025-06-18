using Base.Auths.Permissions;

namespace IMIS.Application.UserOfficeModule
{
    public class UserOfficePermission : BaseOperationPermission
    {
        public override string ModuleName => "UserOffice";
        public override string PermissionGroup => PermissionGrouper.Setting;

    }
}
