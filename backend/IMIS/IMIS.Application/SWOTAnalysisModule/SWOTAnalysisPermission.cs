using Base.Auths.Permissions;

namespace IMIS.Application.SWOTAnalysisModule
{
    public class SWOTAnalysisPermission : BaseOperationPermission
    {
        public override string ModuleName => "SWOTAnalysis";

        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
