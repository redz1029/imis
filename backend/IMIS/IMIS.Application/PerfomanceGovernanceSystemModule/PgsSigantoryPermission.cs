using Base.Auths.Permissions;

namespace IMIS.Application.PerfomanceGovernanceSystemModule
{
    public class PgsSigantoryPermission : BaseOperationPermission
    {
        public override string ModuleName => "Signatory";
        public override string PermissionGroup => PermissionGrouper.Transaction;

        public string Delete => $"Delete{ModuleName}";
    }
}
