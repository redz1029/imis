using Base.Auths.Permissions;

namespace IMIS.Application.SWOTAnalysisServiceHeadModule
{
    public class SWOTAnalysisServiceHeadPermission : BaseOperationPermission
    {
        public override string ModuleName => "SWOTAnalysisServiceHead";

        public override string PermissionGroup => PermissionGrouper.Transaction;
        public string Delete => $"Delete{ModuleName}";
    }
}
