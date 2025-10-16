using Base.Auths.Permissions;

namespace IMIS.Application.BreakThroughScoringModule
{
    public class BreakThroughScoringPermission : BaseOperationPermission
    {
        public override string ModuleName => "BreakThroughScoring";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
