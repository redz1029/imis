using Base.Auths.Permissions;

namespace IMIS.Application.PositionQualificationStandardModule
{
    public class PositionQualificationStandardPermission : BaseOperationPermission
    {
        public override string ModuleName => "PositionQualificationStandard";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
