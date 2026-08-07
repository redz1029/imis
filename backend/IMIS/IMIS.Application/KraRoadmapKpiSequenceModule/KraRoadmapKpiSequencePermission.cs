using Base.Auths.Permissions;

namespace IMIS.Application.KraRoadmapKpiSequenceModule
{
    public class KraRoadmapKpiSequencePermission : BaseOperationPermission
    {
        public override string ModuleName => "KraRoadmapKpiSequence";

        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
