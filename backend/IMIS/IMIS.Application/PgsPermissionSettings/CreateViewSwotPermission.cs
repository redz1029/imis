using Base.Auths.Permissions;

namespace IMIS.Application.PgsPermissionSettings
{
    public class CreateViewSwotPermission : BaseOperationPermission
    {
        public override string ModuleName => "CreateViewSwotSetting";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
