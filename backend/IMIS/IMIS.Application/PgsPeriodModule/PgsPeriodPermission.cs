

using Base.Auths.Permissions;

namespace IMIS.Application.PgsPeriodModule
{
    public class PgsPeriodPermission : BaseOperationPermission
    {
        public override string ModuleName => "Period";

        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
