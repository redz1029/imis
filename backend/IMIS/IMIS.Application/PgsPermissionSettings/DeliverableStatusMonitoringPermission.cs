using Base.Auths.Permissions;

namespace IMIS.Application.PgsPermissionSettings
{
    public class DeliverableStatusMonitoringPermission : BaseOperationPermission
    {
        public override string ModuleName => "DeliverableStatusMonitoringSetting";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
