

using IMIS.Application.PgsDeliverableModule;

namespace IMIS.Application.PgsDeliverableScoreHistoryModule
{
    public class PgsDeliverableScoreHistoryPermission : BaseAuditorPermission
    {
        public override string ModuleName => "PgsDeliverableScoreHistory";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
