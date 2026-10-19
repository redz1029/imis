using Base.Auths.Permissions;

namespace IMIS.Application.AuditProgrammeModule
{
    public class AuditProgrammePermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditProgramme";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        public const string CanSubmitForApproval = "AuditProgramme.SubmitForApproval";
        public const string CanNote = "AuditProgramme.Note";
        public const string CanApprove = "AuditProgramme.Approve";
        public const string CanReject = "AuditProgramme.Reject";
        public const string CanViewAll = "AuditProgramme.ViewAll";
    }
}
