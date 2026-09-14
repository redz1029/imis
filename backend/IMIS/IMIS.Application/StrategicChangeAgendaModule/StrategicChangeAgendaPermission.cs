using Base.Auths.Permissions;

namespace IMIS.Application.StrategicChangeAgendaModule
{
    public class StrategicChangeAgendaPermission : BaseOperationPermission
    {
        public override string ModuleName => "StrategicChangeAgenda";

        public override string PermissionGroup => PermissionGrouper.Transaction;
        public string Delete => $"Delete{ModuleName}";
    }
}
