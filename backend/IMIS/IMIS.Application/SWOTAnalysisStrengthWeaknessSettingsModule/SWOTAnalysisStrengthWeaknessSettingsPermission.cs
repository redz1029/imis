using Base.Auths.Permissions;

namespace IMIS.Application.SWOTAnalysisStrengthWeaknessModule
{
    public class SWOTAnalysisStrengthWeaknessSettingsPermission : BaseOperationPermission
    {
        public override string ModuleName => "SWOTAnalysisStrengthWeakness";

        public override string PermissionGroup => PermissionGrouper.Setting;
        public string Delete => $"Delete{ModuleName}";
    }
}
