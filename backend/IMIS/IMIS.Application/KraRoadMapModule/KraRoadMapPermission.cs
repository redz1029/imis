using Base.Auths.Permissions;

namespace IMIS.Application.KraRoadMapModule
{
    public class KraRoadMapPermission : BaseOperationPermission
    {
        public override string ModuleName => "KraRoadMap";

        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
