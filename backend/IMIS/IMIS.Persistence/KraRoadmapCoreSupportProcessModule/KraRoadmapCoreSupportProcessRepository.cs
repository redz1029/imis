using Base.Abstractions;
using IMIS.Application.KraRoadmapCoreSupportProcessModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadmapCoreSupportProcessModule
{
    public class KraRoadmapCoreSupportProcessRepository : BaseRepository<KraRoadmapCoreSupportProcess, int, ImisDbContext, User>, IKraRoadmapCoreSupportProcessRepository
    {
        public KraRoadmapCoreSupportProcessRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        
        public async Task<List<KraProcessGroupedDto>> GetGroupedAsync(int kraRoadMapPeriodId, CancellationToken cancellationToken)
        {
            var groupedData = await ReadOnlyDbContext.Set<KraRoadmapProcessKraAssignment>()
                .AsNoTracking()
                .Where(x => !x.IsDeleted)
                .Join(ReadOnlyDbContext.Set<KeyResultArea>(),
                    a => a.KraId,
                    k => k.Id,
                    (a, k) => new
                    {
                        a.ProcessId,
                        Kra = k
                    })
                .GroupBy(x => x.ProcessId)
                .Select(g => new KraProcessGroupedDto
                {
                    ProcessId = g.Key,

                    Kras = g.Select(x => new ReportKraDto
                    {
                        Id = x.Kra.Id,
                        Name = x.Kra.Name,
                        Remarks = x.Kra.Remarks,
                        StrategicObjective = x.Kra.StrategicObjective
                    }).ToList()
                })
                .ToListAsync(cancellationToken);

            if (!groupedData.Any())
                return groupedData;

            var kraIds = groupedData
                .SelectMany(x => x.Kras)
                .Select(k => k.Id)
                .Distinct()
                .ToList();
          
            var kraRoadmaps = await ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Where(r =>
                    !r.IsDeleted &&
                    r.KraId.HasValue &&
                    kraIds.Contains(r.KraId.Value) &&
                    r.KraRoadMapPeriodId == kraRoadMapPeriodId)
                .Select(r => new
                {
                    KraId = r.KraId!.Value,

                    RawKpis = r.Kpis!
                        .Where(k => !k.IsDeleted)
                        .Select(k => new
                        {
                            k.Id,
                            k.KpiDescription,
                            k.Target,
                            k.BaseLine,
                            k.Year,

                            Sequence = k.KraRoadmapKpiSequence != null ? k.KraRoadmapKpiSequence.SequenceCode : null
                        })
                        .ToList(),

                    DeliverableYears = r.Deliverables!
                        .Where(d => !d.IsDeleted)
                        .Select(d => d.Year)
                        .Distinct()
                        .OrderBy(y => y)
                        .ToList()
                })
                .ToListAsync(cancellationToken);
         
            var strategyReviewActuals = await ReadOnlyDbContext
                .Set<StrategyReviewDeliverableKpi>()
                .AsNoTracking()
                .Where(x => !x.IsDeleted)
                .Join(
                    ReadOnlyDbContext.Set<StrategyReview>()
                        .Where(sr => !sr.IsDeleted),
                    kpi => kpi.StrategyReviewId,
                    sr => sr.Id,
                    (kpi, sr) => new
                    {
                        kpi.Measure,
                        kpi.ActualDate,
                        sr.StrategyReviewPeriodId
                    })
                .Join(
                    ReadOnlyDbContext.Set<StrategyReviewPeriod>(),
                    x => x.StrategyReviewPeriodId,
                    period => period.Id,
                    (x, period) => new
                    {
                        x.Measure,
                        x.ActualDate,
                        Year = period.StartDate.Year
                    })
                .ToListAsync(cancellationToken);
         
            foreach (var process in groupedData)
            {
                foreach (var kra in process.Kras)
                {
                    var roadmap = kraRoadmaps
                        .FirstOrDefault(x => x.KraId == kra.Id);

                    if (roadmap == null)
                        continue;

                    kra.Years = roadmap.DeliverableYears;

                    kra.Kpis = roadmap.RawKpis
                        .GroupBy(x => new
                        {
                            KpiDescription = (x.KpiDescription ?? "").Trim(),
                            Sequence = x.Sequence
                        })
                        .Select(group =>
                        {
                            var first = group
                                .OrderBy(x => x.Year ?? int.MaxValue)
                                .First();

                            var dto = new ReportKraRoadMapKpiDto
                            {
                                Id = first.Id,
                                Sequence = first.Sequence,
                                KpiDescription = first.KpiDescription,
                                Target = first.Target,
                                BaseLine = first.BaseLine,
                                PercentAccomplished = new List<string?>(),
                                Targets = new List<string?>()
                            };

                            var yearMap = group
                                .Where(x => x.Year.HasValue)
                                .GroupBy(x => x.Year!.Value)
                                .ToDictionary(
                                    x => x.Key,
                                    x => x.First());

                            foreach (var year in roadmap.DeliverableYears)
                            {
                                yearMap.TryGetValue(year, out var row);
                            
                                dto.Targets.Add(
                                    FormatValue(row?.Target));
                             
                                if (row == null)
                                {
                                    dto.PercentAccomplished.Add("0");
                                    continue;
                                }
                               
                                var actuals = strategyReviewActuals
                                    .Where(x => x.Year == year && string.Equals(x.Measure?.Trim(), row.KpiDescription?.Trim(), StringComparison.OrdinalIgnoreCase))
                                    .ToList();

                                if (!actuals.Any())
                                {
                                    dto.PercentAccomplished.Add("0");
                                    continue;
                                }

                                var parsedValues = actuals.Select(x => ParseActualValue(x.ActualDate)).ToList();
                            
                                bool isPercent = actuals.Any(x => !string.IsNullOrWhiteSpace(x.ActualDate) && x.ActualDate.Contains('%'));

                                decimal result = isPercent ? parsedValues.Average() : parsedValues.Sum();

                                result = decimal.Round(result, 2);

                                dto.PercentAccomplished.Add(isPercent ? $"{result}%" : result.ToString("#,##0.##"));
                            }

                            return dto;
                        })
                        .ToList();
                }
            }

            return groupedData;
        }

        private static decimal ParseActualValue(string? raw)
        {
            if (string.IsNullOrWhiteSpace(raw))
                return 0m;

            raw = raw.Replace("%", "").Replace(",", "").Trim();

            return decimal.TryParse(raw, out var value) ? value : 0m;
        }

      
        private static string? FormatValue(string? raw)
        {
            if (string.IsNullOrWhiteSpace(raw))
                return raw;

            if (raw.Contains('%'))
                return raw;

            var cleaned = raw.Replace(",", "").Trim();

            return decimal.TryParse(cleaned, out var value) ? value.ToString("#,##0.##") : raw;
        }
       
        public async Task<Dictionary<int, string?>> GetProcessNamesAsync(List<int> processIds, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadmapCoreSupportProcess>()
                .AsNoTracking()
                .Where(p => processIds.Contains(p.Id))
                .ToDictionaryAsync(p => p.Id, p => p.ProcessName, cancellationToken);
        }

    }
}

