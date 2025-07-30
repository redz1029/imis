using Base.Auths.Permissions;

namespace IMIS.Application.PgsDeliverableHistoryModule
{
    public class PgsDeliverableHistoryPermission : BaseOperationPermission
    {
        public override string ModuleName => "PgsDeliverableHistory";
        public override string PermissionGroup => PermissionGrouper.Transaction;

    }
}
