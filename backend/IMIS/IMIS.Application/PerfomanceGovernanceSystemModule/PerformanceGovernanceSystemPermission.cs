using Base.Auths.Permissions;

namespace IMIS.Application.PerfomanceGovernanceSystemModule
{
    public class PerformanceGovernanceSystemPermission : BaseOperationPermission
    {
        public override string ModuleName => "PerformanceGovernanceSystem";     
        public override string PermissionGroup => PermissionGrouper.Transaction;        
        public string Disapprove => $"Disapprove{ModuleName}";
        public string Submit => $"Submit{ModuleName}";
        public string Confirm => $"Confirm{ModuleName}";
        public string Draft => $"Draft{ModuleName}";
        public string Delete => $"Delete{ModuleName}";

    }
}

