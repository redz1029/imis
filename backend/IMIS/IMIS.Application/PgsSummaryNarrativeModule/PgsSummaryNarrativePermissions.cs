using Base.Auths.Permissions;

namespace IMIS.Application.PgsSummaryNarrativeModule
{
    public class PgsSummaryNarrativePermissions : BaseOperationPermission
    {
        public override string ModuleName => "PgsSummaryNarrative";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
