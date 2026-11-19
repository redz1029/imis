using Base.Auths.Permissions;

namespace IMIS.Application.PolicyAndProcedureSectionNumberingModule
{
    public class PolicyAndProcedureSectionNumberingPermission : BaseOperationPermission
    {
        public override string ModuleName => "PolicyAndProcedureSectionNumbering";

        public override string PermissionGroup => PermissionGrouper.Setting;
        public string Delete => $"Delete{ModuleName}";
    }
}
