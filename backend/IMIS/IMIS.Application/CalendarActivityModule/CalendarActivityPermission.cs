using Base.Auths.Permissions;

namespace IMIS.Application.CalendarActivityModule
{
    public class CalendarActivityPermission : BaseOperationPermission
    {
        public override string ModuleName => "CalendarActivity";

        public override string PermissionGroup => PermissionGrouper.Transaction;
        public string Delete => $"Delete{ModuleName}";
    }
}
