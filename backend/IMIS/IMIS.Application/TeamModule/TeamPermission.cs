using Base.Auths.Permissions;

namespace IMIS.Application.TeamModule
{
    public class TeamPermission : BaseOperationPermission
    {
        public override string ModuleName => "Team";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
