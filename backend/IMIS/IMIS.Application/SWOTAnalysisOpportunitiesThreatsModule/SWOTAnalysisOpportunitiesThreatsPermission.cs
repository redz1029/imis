using Base.Auths.Permissions;

namespace IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule
{
    public class SWOTAnalysisOpportunitiesThreatsPermission : BaseOperationPermission
    {
        public override string ModuleName => "SWOTAnalysisOpportunitiesThreats";

        public override string PermissionGroup => PermissionGrouper.Setting;
        public string Delete => $"Delete{ModuleName}";
    }
}
