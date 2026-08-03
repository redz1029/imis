using Base.Auths.Permissions;

namespace IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule
{
    public class ImpactStrategicGoalScoreCardPeriodPermission : BaseOperationPermission
    {
        public override string ModuleName => "ImpactStrategicGoalScoreCardPeriod";

        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
