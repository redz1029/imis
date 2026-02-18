using Base.Auths.Permissions;

namespace IMIS.Application.KraRoadmapKpiAccomplishmentModule
{
    public class KraRoadMapKpiAccomplishmentPermission : BaseOperationPermission
    {
        public override string ModuleName => "KraRoadMapKpiAccomplishment";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
