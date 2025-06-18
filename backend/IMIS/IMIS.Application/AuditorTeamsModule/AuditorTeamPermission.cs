using Base.Auths.Permissions;

namespace IMIS.Application.AuditorTeamsModule
{
    public class AuditorTeamPermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditorTeam";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
