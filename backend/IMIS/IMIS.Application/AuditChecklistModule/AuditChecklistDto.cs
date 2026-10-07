using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditChecklistModule
{
    public class AuditChecklistDto : BaseDto<AuditChecklist, int>
    {
        public bool? Conforming { get; set; }
        public string? FindingAndRemarks { get; set; }

        public required int AuditPlanEntryId { get; set; }

        // FIX: AuditSchedule is now required on the entity — must be set
        // here too, or ToEntity() fails the same way AuditScheduleId did.
        public required int AuditScheduleId { get; set; }

        public required int AuditChecklistQNAId { get; set; }

        // ---- Read-only display fields, fetched from the linked entities.
        // Populated only when the repository query included the relevant
        // navigation properties — never read back on save. ----
        public string? Criteria { get; set; }
        public string? ItemsAndQuestions { get; set; }

        // ---- Audit Schedule header fields (source of truth). Populated
        // from AuditSchedule -> Team / AuditPlanEntry / AuditPlan ->
        // AuditProgramme so the CRMC form can render without a second
        // request. Never read back on save. ----
        public int? TeamId { get; set; }
        public string? TeamName { get; set; }
        public string? OfficeProcess { get; set; }
        public string? AuditorNames { get; set; }
        public string? AuditScope { get; set; }

        // SINGLE Auditee FK + display name (kept for existing data).
        public int? AuditeeId { get; set; }
        public string? AuditeeName { get; set; }

        // Free-typed auditee string from the CRMC form header. Backend
        // deliberately does NOT model this as a navigation/entity — the form
        // only needs the auditee text. Used as display value; kept in sync
        // on save via AuditeeName.
        public string? Auditees { get; set; }

        public AuditChecklistDto() { }

        [SetsRequiredMembers]
        public AuditChecklistDto(AuditChecklist entity)
        {
            Id = entity.Id;
            Conforming = entity.Conforming;
            FindingAndRemarks = entity.FindingAndRemarks;
            AuditPlanEntryId = entity.AuditPlanEntryId;
            AuditScheduleId = entity.AuditScheduleId;
            AuditChecklistQNAId = entity.AuditChecklistQNAId;
            AuditeeId = entity.AuditeeId;
            Auditees = entity.Auditees;

            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            if (entity.AuditChecklistQNA != null)
            {
                ItemsAndQuestions = entity.AuditChecklistQNA.Question;
                Criteria = entity.AuditChecklistQNA.IsoStandard?.ClauseRef;
            }

            // --- Schedule header mapping (Audit Schedule is the source of truth).
            AuditSchedule? schedule = entity.AuditSchedule;
            AuditPlanEntry? entry = entity.AuditPlanEntry;

            // If the schedule itself was NOT loaded but the checklist row
            // carries an AuditScheduleId, still try the entry relationships.
            if (schedule?.Team != null)
            {
                TeamId = schedule.Team.Id;
                TeamName = schedule.Team.Name;
            }

            var processes = entry?.AuditPlanProcesses;
            if (processes != null && processes.Any())
            {
                OfficeProcess = string.Join(", ", processes
                    .Select(p => p.Office?.Name ?? p.ProcessName)
                    .Where(n => !string.IsNullOrWhiteSpace(n)));
            }

            // Auditors come from the team assigned to the schedule via the
            // entry's IsoAuditors rows (team member names), joined by the
            // linked Team navigation.
            var isoAuditors = entry?.IsoAuditors;
            if (isoAuditors != null && isoAuditors.Any())
            {
                var names = new List<string>();
                foreach (var a in isoAuditors)
                {
                    if (a?.IsoAuditors?.Name is { Length: > 0 } n)
                        names.Add(n);
                }

                // Fall back to the team name when no individual auditor
                // navigation was loaded.
                if (names.Count == 0 && TeamName is { Length: > 0 })
                    names.Add(TeamName);

                AuditorNames = names.Distinct().Any() ? string.Join(", ", names.Distinct()) : null;
            }
            else if (TeamName is { Length: > 0 })
            {
                AuditorNames = TeamName;
            }

            // Scope bubbles up from Audit Schedule -> Audit Plan ->
            // Audit Programme.
            var scope = schedule?.AuditPlan?.AuditProgramme?.ScopeOfAudit
                ?? schedule?.AuditPlan?.AuditProgramme?.ScopeAndFreqAudit;
            if (!string.IsNullOrWhiteSpace(scope))
            {
                AuditScope = scope.Trim();
            }
            else if (schedule?.AuditPlan?.PlanName is { Length: > 0 } planName)
            {
                AuditScope = planName;
            }

            if (entity.Auditee != null)
            {
                AuditeeName = entity.Auditee.Name;
                // Keep the free-typed auditee string consistent with the
                // stored Auditee link when a checklist already exists.
                if (string.IsNullOrWhiteSpace(Auditees) && !string.IsNullOrWhiteSpace(AuditeeName))
                    Auditees = AuditeeName;
            }
        }

        public override AuditChecklist ToEntity()
        {
            return new AuditChecklist
            {
                Id = Id,
                Conforming = Conforming,
                FindingAndRemarks = FindingAndRemarks,
                AuditPlanEntryId = AuditPlanEntryId,
                AuditScheduleId = AuditScheduleId,
                AuditChecklistQNAId = AuditChecklistQNAId,
                AuditeeId = AuditeeId,
                Auditees = Auditees,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}