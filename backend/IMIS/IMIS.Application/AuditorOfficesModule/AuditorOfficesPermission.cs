using Base.Auths.Permissions;

namespace IMIS.Application.AuditorOfficesModule
{
    public class AuditorOfficesPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditorOffices";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
