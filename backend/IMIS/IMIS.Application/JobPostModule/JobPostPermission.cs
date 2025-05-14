using Base.Auths.Permissions;

namespace IMIS.Application.JobPostModule
{
    public class JobPostPermission : BaseOperationPermission
    {
        public override string ModuleName => "JobPost";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
