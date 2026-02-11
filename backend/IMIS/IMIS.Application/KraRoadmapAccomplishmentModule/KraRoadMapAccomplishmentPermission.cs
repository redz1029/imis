using Base.Auths.Permissions;

namespace IMIS.Application.KraRoadmapAccomplishmentModule
{
    public class KraRoadMapAccomplishmentPermission : BaseOperationPermission
    {
        public override string ModuleName => "KraRoadMapAccomplishment";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
