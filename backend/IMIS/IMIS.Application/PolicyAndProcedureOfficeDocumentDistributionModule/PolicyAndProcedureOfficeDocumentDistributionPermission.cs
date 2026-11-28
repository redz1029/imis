using Base.Auths.Permissions;

namespace IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionModule
{
    public class PolicyAndProcedureOfficeDocumentDistributionPermission : BaseOperationPermission
    {
        public override string ModuleName => "PolicyAndProcedureOfficeDocumentDistribution";
        public override string PermissionGroup => PermissionGrouper.Transaction;
        public string Delete => $"Delete{ModuleName}";
    }
}
