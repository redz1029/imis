using System.Collections.Generic;

namespace IMIS.Application.AuditChecklistModule
{
    /// <summary>
    /// Clause assignment board of one audit schedule's checklist. For an auditor
    /// it only contains their own clauses and <see cref="CanAssign"/> is false.
    /// </summary>
    public class AuditChecklistAssignmentsDto
    {
        public int AuditScheduleId { get; set; }
        public int? TeamId { get; set; }
        public string? TeamName { get; set; }
        public bool CanAssign { get; set; }

        /// <summary>True for an auditor of the team: they only see and answer their own clauses.</summary>
        public bool OwnClausesOnly { get; set; }
        public List<AuditChecklistClauseAssignmentDto> Clauses { get; set; } = new();
        public List<AuditChecklistAuditorDto> Auditors { get; set; } = new();
    }

    public class AuditChecklistClauseAssignmentDto
    {
        public long IsoStandardId { get; set; }
        public string ClauseRef { get; set; } = string.Empty;
        public string? Particulars { get; set; }
        public int? AssignedAuditorId { get; set; }
        public string? AssignedAuditorName { get; set; }
        public int QuestionCount { get; set; }
        public int AnsweredCount { get; set; }
    }

    public class AuditChecklistAuditorDto
    {
        public int AuditorId { get; set; }
        public string Name { get; set; } = string.Empty;
        public bool IsTeamLeader { get; set; }
        public int AssignedClauseCount { get; set; }
        public int QuestionCount { get; set; }
        public int AnsweredCount { get; set; }
    }

    /// <summary>One clause -> auditor pair; a null auditor clears the assignment.</summary>
    public class AuditChecklistAssignmentRequestItem
    {
        public long IsoStandardId { get; set; }
        public int? AuditorId { get; set; }
    }
}
