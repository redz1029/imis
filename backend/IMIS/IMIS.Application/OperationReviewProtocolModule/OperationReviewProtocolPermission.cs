using Base.Auths.Permissions;

namespace IMIS.Application.OperationReviewProtocolModule
{
    public class OperationReviewProtocolPermission : BaseOperationPermission
    {
        public override string ModuleName => "OperationReviewProtocol";
        public override string PermissionGroup => PermissionGrouper.Transaction;
        public string Delete => $"Delete{ModuleName}";
    }
}
