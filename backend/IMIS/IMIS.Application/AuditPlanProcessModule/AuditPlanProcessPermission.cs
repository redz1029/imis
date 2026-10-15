using Base.Auths.Permissions;

namespace IMIS.Application.AuditPlanProcessModule
{
    public class AuditPlanProcessPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditPlanProcess";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        // Additional specific permissions for audit plan processes
        public const string CanActivate = "AuditPlanProcess.Activate";
        public const string CanDeactivate = "AuditPlanProcess.Deactivate";
        public const string CanViewAll = "AuditPlanProcess.ViewAll";
    }
}