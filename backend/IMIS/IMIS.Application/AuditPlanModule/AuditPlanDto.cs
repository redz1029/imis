using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Application.AuditPlanApprovalModule;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanDto : BaseDto<AuditPlan, int>
    {
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }
        public required string PreparerId { get; set; }
        public string? PreparerName { get; set; }
        public required string SelectedApproverId { get; set; }
        public string? SelectedApproverName { get; set; }
        public required string PlanStatus { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? LastModifiedDate { get; set; }

        public List<AuditPlanEntryDto>? Entries { get; set; }
        public List<AuditPlanApprovalDto>? Approvals { get; set; }

        public AuditPlanDto() { }

        [SetsRequiredMembers]
        public AuditPlanDto(AuditPlan auditPlan)
        {
            Id = auditPlan.Id;
            StartDate = auditPlan.StartDate;
            EndDate = auditPlan.EndDate;
            PreparerId = auditPlan.PreparerId;
            PreparerName = auditPlan.Preparer != null ? $"{auditPlan.Preparer.FirstName} {auditPlan.Preparer.LastName}" : null;
            SelectedApproverId = auditPlan.SelectedApproverId;
            SelectedApproverName = auditPlan.SelectedApprover != null ? $"{auditPlan.SelectedApprover.FirstName} {auditPlan.SelectedApprover.LastName}" : null;
            PlanStatus = auditPlan.PlanStatus;
            CreatedDate = auditPlan.CreatedDate;
            LastModifiedDate = auditPlan.LastModifiedDate;
        }

        public override AuditPlan ToEntity()
        {
            return new AuditPlan
            {
                Id = Id,
                StartDate = StartDate,
                EndDate = EndDate,
                PreparerId = PreparerId,
                SelectedApproverId = SelectedApproverId,
                PlanStatus = PlanStatus,
                CreatedDate = CreatedDate,
                LastModifiedDate = LastModifiedDate
            };
        }
    }
}