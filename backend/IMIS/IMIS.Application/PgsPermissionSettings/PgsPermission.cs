using Base.Auths.Permissions;

namespace IMIS.Application.PermissionSettings
{
    public class PgsPermission : BaseOperationPermission
    {
        public override string ModuleName => "PGSSetting";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
