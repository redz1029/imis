using Base.Auths.Permissions;

namespace IMIS.Application.PermissionSettings
{
    public class CreateViewRoadmapPermission : BaseOperationPermission
    {
        public override string ModuleName => "CreateViewRoadmapSetting";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
