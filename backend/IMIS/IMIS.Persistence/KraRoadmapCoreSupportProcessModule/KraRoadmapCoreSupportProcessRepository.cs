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
                      (a, k) => new { a.ProcessId, Kra = k })
                .GroupBy(x => x.ProcessId)
                .Select(g => new KraProcessGroupedDto
                {
                    ProcessId = g.Key,
                    Kras = g.Select(x => new ReportKraDto
                    {
                        Id = x.Kra.Id,  
                        Name = x.Kra.Name,
                        Remarks = x.Kra.Remarks,
                        StrategicObjective = x.Kra.StrategicObjective,
                        Kpis = new List<ReportKraRoadMapKpiDto>(),
                        Years = new List<int>()
                    }).ToList()
                })
                .ToListAsync(cancellationToken);

            if (!groupedData.Any())
                return groupedData;

            var kraIds = groupedData.SelectMany(g => g.Kras.Select(k => k.Id)).ToList();

            var kraRoadmaps = await ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Where(r => r.KraId.HasValue
                            && kraIds.Contains(r.KraId.Value)
                            && r.KraRoadMapPeriodId == kraRoadMapPeriodId
                            && !r.IsDeleted)
                .Select(r => new
                {
                    KraId = r.KraId!.Value,
                    Kpis = r.Kpis!
                        .Where(k => !k.IsDeleted)
                         .Select(k => new ReportKraRoadMapKpiDto
                         {
                             Id = k.Id, 
                             KpiDescription = k.KpiDescription,
                             Target = k.Target,
                             BaseLine = k.BaseLine,
                             PercentAccomplished = null
                         }).ToList(),
                         DeliverableYears = r.Deliverables!
                        .Where(d => !d.IsDeleted)
                        .Select(d => d.Year)
                        .Distinct()
                        .ToList()
                })
                .ToListAsync(cancellationToken);

            var allKpiIds = kraRoadmaps.SelectMany(r => r.Kpis.Select(k => k.Id)).ToList();

            var kpiAccomplishments = await ReadOnlyDbContext.Set<KraRoadmapKpiAccomplishment>()
                .AsNoTracking()
                .Where(a => allKpiIds.Contains(a.KraRoadMapKpiId) && !a.IsDeleted)
                .Select(a => new
                {
                    a.KraRoadMapKpiId,
                    PercentAccomplished = (decimal?)a.PercentAccomplished
                })
                .ToListAsync(cancellationToken);

            foreach (var process in groupedData)
            {
                foreach (var kra in process.Kras)
                {
                    var roadmap = kraRoadmaps.FirstOrDefault(r => r.KraId == kra.Id);
                    if (roadmap != null)
                    {
                        kra.Kpis = roadmap.Kpis;

                        foreach (var kpi in kra.Kpis!)
                        {
                            var accomplishments = kpiAccomplishments
                                .Where(a => a.KraRoadMapKpiId == kpi.Id)
                                .Select(a => a.PercentAccomplished ?? 0m)
                                .ToList();

                            kpi.PercentAccomplished = accomplishments;
                        }

                        kra.Years = roadmap.DeliverableYears;
                    }
                }
            }

            return groupedData;
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

