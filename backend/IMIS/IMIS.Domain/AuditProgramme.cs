using Base.Primitives;
using System;
using System.Collections.Generic;

namespace IMIS.Domain
{
    public class AuditProgramme : Entity<int>
    {
        public int Year { get; set; }
        public required string For { get; set; }
        public required string From { get; set; }
        public required string Purpose { get; set; }

        public ICollection<AuditProgrammeObjective> Objectives { get; set; } = new List<AuditProgrammeObjective>();

        public required string ScopeAndFreqAudit { get; set; }
        public required string InternalAuditSched { get; set; }
        public required string AuditPlanObjective { get; set; }
        public required string ScopeOfAudit { get; set; }

        public required string AuditCriteria { get; set; }
        public required string AuditMethodology { get; set; }
        public required string SelectionAndEvaluationOfAuditors { get; set; }
        public required string Reporting { get; set; }
        public required string VerificationOfPreviousNonconformities { get; set; }
        public required string AuditLimitations { get; set; }

        
        public int AuditStatusId { get; set; } = AuditStatusSeedIds.Draft;
        public AuditPlanStatus? AuditStatus { get; set; }

        public ICollection<AuditProgrammeStatusHistory> StatusHistory { get; set; } = new List<AuditProgrammeStatusHistory>();

        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
        public DateTime? LastModifiedDate { get; set; }
        public ICollection<AuditPlanApproval> Approvals { get; set; } = new List<AuditPlanApproval>();
        public ICollection<AuditPlan> AuditPlans { get; set; } = new List<AuditPlan>();
    }
}