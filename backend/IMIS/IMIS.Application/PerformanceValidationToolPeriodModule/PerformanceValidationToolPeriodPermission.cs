using Base.Auths.Permissions;

namespace IMIS.Application.PerformanceValidationToolPeriodModule
{
    public class PerformanceValidationToolPeriodPermission : BaseOperationPermission
    {
        public override string ModuleName => "PerformanceValidationToolPeriod";

        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
