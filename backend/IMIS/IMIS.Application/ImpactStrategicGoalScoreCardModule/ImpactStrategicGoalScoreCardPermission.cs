

using Base.Auths.Permissions;

namespace IMIS.Application.ImpactStrategicGoalScoreCardModule
{
    public class ImpactStrategicGoalScoreCardPermission : BaseOperationPermission
    {
        public override string ModuleName => "ImpactStrategicGoalScoreCard";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
