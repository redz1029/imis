using Base.Auths.Permissions;

namespace IMIS.Application.PgsDeliverableModule
{
    public class PgsDeliverableServiceHeadPermission : BaseOperationPermission
    {
        public override string ModuleName => "PgsDeliverableServiceHead";
        public override string PermissionGroup => PermissionGrouper.Report;
    }
}
