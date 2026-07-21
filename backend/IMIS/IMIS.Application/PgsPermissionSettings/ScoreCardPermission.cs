using Base.Auths.Permissions;

namespace IMIS.Application.PgsPermissionSettings
{
    public class ScoreCardPermission : BaseOperationPermission
    {
        public override string ModuleName => "ScoreCardSetting";
        public override string PermissionGroup => PermissionGrouper.Report;
    }
}
