using Base.Auths.Permissions;

namespace IMIS.Application.PgsDeliverableModule
{
    public class PgsDeliverablePermission : BaseOperationPermission
    {
        public override string ModuleName => "PgsDeliverable";
        public override string PermissionGroup => PermissionGrouper.Setting;

    }
}
