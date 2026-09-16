using Base.Auths.Permissions;

namespace IMIS.Application.PgsPermissionSettings
{
    public class StrategicChangeAgendaPermissionSetting : BaseOperationPermission
    {
        public override string ModuleName => "StrategicChangeAgendaSettings";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
