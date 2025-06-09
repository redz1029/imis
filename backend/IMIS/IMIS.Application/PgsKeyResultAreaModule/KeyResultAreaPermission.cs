

using Base.Auths.Permissions;

namespace IMIS.Application.PgsKeyResultAreaModule
{
    public class KeyResultAreaPermission : BaseOperationPermission
    {
        public override string ModuleName => "Kra";

        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
