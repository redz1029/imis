using Base.Auths.Permissions;

namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentPermission : BaseOperationPermission
    {
        public override string ModuleName => "PgsDeliverableAccomplishment";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
