using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PgsSummaryNarrativeModule;
using IMIS.Domain;

namespace IMIS.Application.PgsSummaryNarrativeModules
{

    public class ReportPGSSummaryNarrativeDto : BaseDto<PgsSummaryNarrative, int>
    {
        public string? Findings { get; set; }
        public string? Recommendation { get; set; }
        public string? Conclusion { get; set; }
        public required PgsPeriodDto PgsPeriod { get; set; }     
        public PgsDeliverableSummaryNarrativeFilter? PgsDeliverableSummaryNarrativeFilter { get; set; }           
        public string PeriodRange => PgsDeliverableSummaryNarrativeFilter?.PgsPeriodId == PgsPeriod.Id ? $"{PgsPeriod.StartDate:MMM dd, yyyy} - {PgsPeriod.EndDate:MMM dd, yyyy}" : string.Empty;        
        public OfficeDto? Office { get; set; }
        public string? OfficeName => PgsDeliverableSummaryNarrativeFilter?.OfficeId != null && Office != null &&  Office.Id.ToString() == PgsDeliverableSummaryNarrativeFilter.OfficeId ? Office.Name : string.Empty;
        public KeyResultAreaDto? KeyResultArea { get; set; }
        public string KraName => PgsDeliverableSummaryNarrativeFilter?.Kra != null && KeyResultArea != null && KeyResultArea.Id.ToString() == PgsDeliverableSummaryNarrativeFilter.Kra ? KeyResultArea.Name : string.Empty;
        public List<PgsDeliverableSummaryNarrativeDto> PgsDeliverables { get; set; } = new();
        
        [SetsRequiredMembers]
        public ReportPGSSummaryNarrativeDto(PgsSummaryNarrative pgsSummaryNarrative, List<PgsDeliverable>? deliverables = null, PgsDeliverableSummaryNarrativeFilter? filter = null, OfficeDto? office = null, KeyResultAreaDto? kra = null)
        {
            this.Id = pgsSummaryNarrative.Id;
            this.Findings = pgsSummaryNarrative.Findings ?? string.Empty;
            this.Recommendation = pgsSummaryNarrative.Recommendation ?? string.Empty;
            this.Conclusion = pgsSummaryNarrative.Conclusion ?? string.Empty;
            this.PgsPeriod = new PgsPeriodDto(pgsSummaryNarrative.PgsPeriod!);           
            this.PgsDeliverableSummaryNarrativeFilter = new PgsDeliverableSummaryNarrativeFilter(
               filter?.PgsPeriodId,
               filter?.OfficeId,
               filter?.Kra,
               filter?.MinScore,
               filter?.MaxScore,
               filter?.Page ?? 1,
               filter?.PageSize ?? 25
            );           
            this.Office = office;
            this.KeyResultArea = kra;

            if (deliverables != null)
            {
                this.PgsDeliverables = deliverables
                .Where(d => d.PerfomanceGovernanceSystem?.PgsPeriod.Id == pgsSummaryNarrative.PgsPeriodId)
                .Select(d => new PgsDeliverableSummaryNarrativeDto
                {
                    PgsDeliverableId = d.Id,
                    PgsPeriod = d.PerfomanceGovernanceSystem!.PgsPeriod.StartDate.ToString("MMM dd, yyyy") + " - " + d.PerfomanceGovernanceSystem.PgsPeriod.EndDate.ToString("MMM dd, yyyy"),
                    Deliverable = d.DeliverableName,
                    IsDirect = d.IsDirect,
                    KeyResultArea = d.Kra?.Name ?? string.Empty,
                    KraDescription = d.KraDescription,
                    Office = d.PerfomanceGovernanceSystem.Office.Name,
                    Score = d.PercentDeliverables,
                    Status = d.Status.ToString(),
                    Remarks = d.Remarks,
                    ByWhen = d.ByWhen
                }).ToList();
            }
        }
        
        public override PgsSummaryNarrative ToEntity()
        {
            return new PgsSummaryNarrative()
            {
                Id = Id,
                Findings = Findings,
                Recommendation = Recommendation,
                Conclusion = Conclusion,
                PgsPeriod = PgsPeriod.ToEntity()
            };
        }
    }
}


