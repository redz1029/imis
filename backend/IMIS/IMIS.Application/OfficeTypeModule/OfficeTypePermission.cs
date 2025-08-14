using Base.Auths.Permissions;

namespace IMIS.Application.OfficeTypeModule
{
    public class OfficeTypePermission : BaseOperationPermission
    {
        public override string ModuleName => "OfficeType";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
