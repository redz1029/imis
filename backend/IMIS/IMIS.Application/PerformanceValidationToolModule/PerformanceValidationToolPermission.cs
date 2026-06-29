using Base.Auths.Permissions;

namespace IMIS.Application.PerformanceValidationToolModule
{
    public class PerformanceValidationToolPermission : BaseOperationPermission
    {
        public override string ModuleName => "PerformanceValidationTool";

        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
