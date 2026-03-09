using Base.Auths.Permissions;

namespace IMIS.Application.AuditPlanEntryModule
{
    public class AuditPlanEntryPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditPlanEntry";
        public override string PermissionGroup => PermissionGrouper.Transaction;

        // Additional specific permissions for audit plan entries
        public const string CanManageEntries = "AuditPlanEntry.ManageEntries";
        public const string CanViewAll = "AuditPlanEntry.ViewAll";
    }
}