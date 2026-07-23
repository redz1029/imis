using Base.Primitives;
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

        // --- Added Sections IV to IX from Document ---

        /// <summary>
        /// IV. Audit Criteria
        /// </summary>
        public required string AuditCriteria { get; set; }

        /// <summary>
        /// V. Audit Methodology
        /// </summary>
        public required string AuditMethodology { get; set; }

        /// <summary>
        /// VI. Selection and Evaluation of Auditors
        /// </summary>
        public required string SelectionAndEvaluationOfAuditors { get; set; }

        /// <summary>
        /// VII. Reporting
        /// </summary>
        public required string Reporting { get; set; }

        /// <summary>
        /// VIII. Verification of Previous Nonconformities / Follow-Up Actions
        /// </summary>
        public required string VerificationOfPreviousNonconformities { get; set; }

        /// <summary>
        /// IX. Audit Limitations
        /// </summary>
        public required string AuditLimitations { get; set; }

        // --- Navigation Properties ---
        public ICollection<AuditPlan> AuditPlans { get; set; } = new List<AuditPlan>();
    }
}