namespace IMIS.Application.PgsDeliverableModule
{
    public class PgsDeliverableAuditorPermission : BaseAuditorPermission
    {
        public override string ModuleName => "PgsDeliverableMonitor";
        public override string PermissionGroup => PermissionGrouper.Report;
    }
}
