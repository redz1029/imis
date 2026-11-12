using System.Collections.Generic;

namespace IMIS.Application.NonconformingActionReportModule
{
    /// <summary>
    /// What the auditor writes on the NCAR: the nature of the report, the clause,
    /// the requirement, the policy reference and the finding.
    /// </summary>
    public class NcarIssuanceRequest
    {
        public string RelevantStandard { get; set; } = string.Empty;
        public string StandardRequirement { get; set; } = string.Empty;
        public string LegalOrPolicyReference { get; set; } = string.Empty;
        public string AuditFindings { get; set; } = string.Empty;

        public bool IsInternalAudit { get; set; }
        public bool IsExternalAudit { get; set; }
        public bool IsNonconformity { get; set; }
        public bool IsInternalCustomer { get; set; }
        public bool IsExternalCustomer { get; set; }
        public bool IsComplaint { get; set; }
        public bool IsResponseRate { get; set; }
        public bool IsOperations { get; set; }
    }

    /// <summary>What the auditee writes: the root causes and the proposed actions.</summary>
    public class NcarResponseRequest
    {
        public List<string> RootCauses { get; set; } = new();
        public List<string> Corrections { get; set; } = new();
        public List<string> CorrectiveActions { get; set; } = new();
    }

    /// <summary>What the auditor writes once the proposed actions were carried out.</summary>
    public class NcarVerificationRequest
    {
        public string VerificationDetails { get; set; } = string.Empty;
    }
}
