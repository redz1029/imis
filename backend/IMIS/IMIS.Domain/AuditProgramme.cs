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

        
        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
        public DateTime? LastModifiedDate { get; set; }

        /// <summary>
        /// Revision counter printed on the Audit Programme form. Starts at 0 and
        /// is bumped when a day change is made to one of its audit plans.
        /// </summary>
        public int Revision { get; set; } = 0;

        public ICollection<AuditPlan> AuditPlans { get; set; } = new List<AuditPlan>();

        /// <summary>
        /// IQA Signatory records for this audit programme (approval workflow)
        /// </summary>
        public ICollection<IQASignatory> IQASignatories { get; set; } = new List<IQASignatory>();

        /// <summary>
        /// Persistent approval and rejection history for this audit programme
        /// </summary>
        public ICollection<IQAApprovalHistory> ApprovalHistories { get; set; } = new List<IQAApprovalHistory>();
    }
}