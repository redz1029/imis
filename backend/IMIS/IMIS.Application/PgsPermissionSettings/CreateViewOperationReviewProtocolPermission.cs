using Base.Auths.Permissions;

namespace IMIS.Application.PgsPermissionSettings
{
    public class CreateViewOperationReviewProtocolPermission : BaseOperationPermission
    {
        public override string ModuleName => "CreateViewOperationReviewProtocolSetting";
        public override string PermissionGroup => PermissionGrouper.Transaction;
    }
}
