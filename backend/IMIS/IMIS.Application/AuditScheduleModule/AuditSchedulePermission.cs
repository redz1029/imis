using Base.Auths.Permissions;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditSchedulePermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditSchedule";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
