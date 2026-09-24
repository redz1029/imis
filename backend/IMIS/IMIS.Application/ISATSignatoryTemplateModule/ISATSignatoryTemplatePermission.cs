using Base.Auths.Permissions;

namespace IMIS.Application.ISATSignatoryTemplateModule
{
    public class ISATSignatoryTemplatePermission : BaseOperationPermission
    {
        public override string ModuleName => "ISATSignatoryTemplate";
        public override string PermissionGroup => PermissionGrouper.Transaction;
        public string Delete => $"Delete{ModuleName}";
        public string Draft => $"Draft{ModuleName}";
        public string Submit => $"Submit{ModuleName}";
        public string Confirm => $"Confirm{ModuleName}";
    }
}
