using Base.Auths.Permissions;

namespace IMIS.Application.OfficeModule
{
    public class OfficePermission : BaseOperationPermission
    {
        public override string ModuleName => "Office";
        public override string PermissionGroup => PermissionGrouper.Setting;

    }
}
