

using Base.Auths.Permissions;

namespace IMIS.Application.ISATModule
{
    public class ISATPermission : BaseOperationPermission
    {
        public override string ModuleName => "ISAT";
        public override string PermissionGroup => PermissionGrouper.Transaction;
        public string Delete => $"Delete{ModuleName}";
        public string Draft => $"Draft{ModuleName}";
        public string Submit => $"Submit{ModuleName}";
        public string Confirm => $"Confirm{ModuleName}";
    }
}
