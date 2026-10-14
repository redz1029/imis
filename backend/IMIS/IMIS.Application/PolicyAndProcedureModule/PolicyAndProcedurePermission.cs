using Base.Auths.Permissions;

namespace IMIS.Application.PolicyAndProcedureModule
{
    public class PolicyAndProcedurePermission : BaseOperationPermission
    {
        public override string ModuleName => "PolicyAndProcedure";
        public override string PermissionGroup => PermissionGrouper.Transaction;
        public string Disapprove => $"Disapprove{ModuleName}";
        public string Submit => $"Submit{ModuleName}";
        public string Confirm => $"Confirm{ModuleName}";
        public string Draft => $"Draft{ModuleName}";
        public string Delete => $"Delete{ModuleName}";
    }
}
