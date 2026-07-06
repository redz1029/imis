using Base.Auths.Permissions;

namespace IMIS.Application.PerformanceValidationToolModule
{
    public class PerformanceValidationToolPermission : BaseOperationPermission
    {
        public override string ModuleName => "PerformanceValidationTool";

        public override string PermissionGroup => PermissionGrouper.Transaction;
        public string Delete => $"Delete{ModuleName}";
        public string Draft => $"Draft{ModuleName}";
        public string Submit => $"Submit{ModuleName}";
    }
}
