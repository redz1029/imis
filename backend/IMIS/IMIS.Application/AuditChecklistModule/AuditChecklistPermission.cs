using Base.Auths.Permissions;

namespace IMIS.Application.AuditChecklistModule
{
    public class AuditChecklistPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditChecklist";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;
    }
}
