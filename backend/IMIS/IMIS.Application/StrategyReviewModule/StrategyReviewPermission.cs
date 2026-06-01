using Base.Auths.Permissions;

namespace IMIS.Application.StrategyReviewModule
{
    public class StrategyReviewPermission : BaseOperationPermission
    {
        public override string ModuleName => "StrategyReview";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
