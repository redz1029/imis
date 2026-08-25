using Base.Auths.Permissions;

namespace IMIS.Application.PgsPermissionSettings
{
    public class CreateViewDeliverablePermission : BaseOperationPermission
    {
        public override string ModuleName => "CreateViewDeliverablesSetting";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
