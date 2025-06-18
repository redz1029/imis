using Base.Auths.Permissions;

namespace IMIS.Application.AuditorModule
{
    public class AuditorPermission : BaseOperationPermission
    {
        public override string ModuleName => "Auditor";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
