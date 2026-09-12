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
        public required int AuditChecklistQNAId { get; set; }

        // ---- Read-only display fields, fetched from the linked entities.
        // Populated only when the repository query included the relevant
        // navigation properties — never read back on save. ----
        public string? Criteria { get; set; }
        public string? ItemsAndQuestions { get; set; }
        public string? OfficeProcess { get; set; }
        public string? AuditTeamName { get; set; }

        public AuditChecklistDto() { }

        [SetsRequiredMembers]
        public AuditChecklistDto(AuditChecklist entity)
        {
            Id = entity.Id;
            Conforming = entity.Conforming;
            FindingAndRemarks = entity.FindingAndRemarks;
            AuditPlanEntryId = entity.AuditPlanEntryId;
            AuditChecklistQNAId = entity.AuditChecklistQNAId;

            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            if (entity.AuditChecklistQNA != null)
            {
                ItemsAndQuestions = entity.AuditChecklistQNA.Question;
                Criteria = entity.AuditChecklistQNA.IsoStandard?.ClauseRef;
            }

            if (entity.AuditPlanEntry != null)
            {
                var processes = entity.AuditPlanEntry.AuditPlanProcesses;
                if (processes != null && processes.Any())
                {
                    OfficeProcess = string.Join(", ", processes
                        .Select(p => p.Office?.Name ?? p.ProcessName)
                        .Where(n => !string.IsNullOrWhiteSpace(n)));
                }

                var auditors = entity.AuditPlanEntry.IsoAuditors;
                if (auditors != null && auditors.Any())
                {
                    AuditTeamName = auditors.FirstOrDefault(a => a.Team != null)?.Team?.Name;
                }
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
                AuditChecklistQNAId = AuditChecklistQNAId,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}