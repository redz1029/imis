using Base.Auths.Permissions;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditSchedulePermission : BaseOperationPermission
    {
        public override string ModuleName => "AuditSchedule";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;
    }

    /// Workflow actions for an Audit Schedule.
    /// The Auditor Team Leader creates and submits a schedule; the Department
    /// Head confirms or rejects it. Kept separate from
    /// <see cref="AuditSchedulePermission"/> so the generic CRUD permission
    /// never implies the decision rights.
    public class AuditScheduleWorkflowPermission : BasePermission
    {
        public override string ModuleName => "AuditScheduleWorkflow";
        public override string PermissionGroup => PermissionGrouper.IQAManagement;

        public string CanSubmit => "AuditScheduleSubmit";
        public string CanConfirm => "AuditScheduleConfirm";
        public string CanReject => "AuditScheduleReject";
        public string CanNote => "AuditScheduleNote";
    }
}
