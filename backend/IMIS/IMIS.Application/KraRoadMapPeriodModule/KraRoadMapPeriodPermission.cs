using Base.Auths.Permissions;

namespace IMIS.Application.KraRoadMapPeriodModule
{
    public class KraRoadMapPeriodPermission : BaseOperationPermission
    {
        public override string ModuleName => "KraRoadMapPeriod";

        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
