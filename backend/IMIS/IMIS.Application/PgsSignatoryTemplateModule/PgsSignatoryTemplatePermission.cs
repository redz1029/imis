using Base.Auths.Permissions;

namespace IMIS.Application.PgsSignatoryTemplateModule
{
    public class PgsSignatoryTemplatePermission : BaseOperationPermission
    {
        public override string ModuleName => "PgsSignatoryTemplate";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
