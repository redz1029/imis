using Base.Auths.Permissions;

namespace IMIS.Application.PolicyAndProcedureHistoryLogModule
{
    public class PolicyAndProcedureHistoryLogPermission : BaseOperationPermission
    {
        public override string ModuleName => "PolicyAndProcedureHistoryLog";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
