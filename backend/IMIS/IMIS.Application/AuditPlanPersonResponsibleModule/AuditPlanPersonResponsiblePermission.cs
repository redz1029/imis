using Base.Auths.Permissions;

namespace IMIS.Application.AuditPlanPersonResponsibleModule
{
    public class AuditPlanPersonResponsiblePermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditPlanPersonResponsible";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        // Additional specific permissions for audit plan person responsible
        public const string CanActivate = "AuditPlanPersonResponsible.Activate";
        public const string CanDeactivate = "AuditPlanPersonResponsible.Deactivate";
        public const string CanViewAll = "AuditPlanPersonResponsible.ViewAll";
    }
}