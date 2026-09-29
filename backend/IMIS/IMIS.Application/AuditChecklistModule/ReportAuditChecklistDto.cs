using Base.Primitives;
using IMIS.Domain;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace IMIS.Application.AuditChecklistModule
{
    public class ReportAuditChecklistRowDto
    {
        public int Id { get; set; }
        public string Criteria { get; set; } = string.Empty;
        public string ItemsAndQuestions { get; set; } = string.Empty;
        public string ConformingDisplay { get; set; } = string.Empty;
        public string FindingAndRemarks { get; set; } = string.Empty;
    }

    public class ReportAuditChecklistDto : BaseDto<AuditChecklist, int>
    {
        public string OfficeProcess { get; set; } = string.Empty;

        // Not present on AuditChecklist, AuditSchedule, or AuditPlanEntry as
        // confirmed — left blank rather than guessed. Wire in if a scope
        // field is added.
        public string AuditScope { get; set; } = string.Empty;

        public string AuditorNames { get; set; } = string.Empty;

        // AuditChecklist.Auditee is a single navigation, not the free-typed
        // multi-name field the Flutter checklist page's combo box writes.
        // Only that single linked Auditee's name prints.
        public string AuditeeNames { get; set; } = string.Empty;

        public List<ReportAuditChecklistRowDto> Rows { get; set; } = new();

        public ReportAuditChecklistDto() { }

        [SetsRequiredMembers]
        public ReportAuditChecklistDto(IEnumerable<AuditChecklist> entities)
        {
            var list = entities.ToList();
            var first = list.FirstOrDefault();

            if (first != null)
            {
                Id = first.AuditScheduleId;

                var entry = first.AuditPlanEntry;
                if (entry != null)
                {
                    if (entry.AuditPlanProcesses != null && entry.AuditPlanProcesses.Any())
                    {
                        var p = entry.AuditPlanProcesses.First();
                        OfficeProcess = p.Office?.Name
                            ?? (!string.IsNullOrWhiteSpace(p.ProcessName) ? p.ProcessName! : string.Empty);
                    }

                    if (entry.IsoAuditors != null && entry.IsoAuditors.Any())
                    {
                        var names = entry.IsoAuditors
                            .Where(a => a.Team != null)
                            .Select(a => a.Team!.Name)
                            .Where(n => !string.IsNullOrEmpty(n));
                        AuditorNames = string.Join(", ", names);
                    }
                }

                AuditeeNames = first.Auditee?.Name ?? string.Empty;
            }

            foreach (var e in list)
            {
                Rows.Add(new ReportAuditChecklistRowDto
                {
                    Id = e.Id,
                    Criteria = e.AuditChecklistQNA?.IsoStandard?.ClauseRef ?? string.Empty,
                    ItemsAndQuestions = e.AuditChecklistQNA?.Question ?? string.Empty,
                    ConformingDisplay = e.Conforming == true ? "Y" : e.Conforming == false ? "N" : string.Empty,
                    FindingAndRemarks = e.FindingAndRemarks ?? string.Empty
                });
            }
        }

        public override AuditChecklist ToEntity()
        {
            return new AuditChecklist
            {
                Id = Id,
                AuditPlanEntryId = 0,
                AuditScheduleId = 0,
                AuditChecklistQNAId = 0,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}