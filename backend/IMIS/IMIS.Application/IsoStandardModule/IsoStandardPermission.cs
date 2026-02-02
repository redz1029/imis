using Base.Auths.Permissions;

namespace IMIS.Application.IsoStandardModule
{
    public class IsoStandardPermission : BaseOperationPermission
    {
        public override string ModuleName => "IsoStandard";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
