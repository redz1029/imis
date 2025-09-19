using Base.Abstractions;
using IMIS.Application.PgsSummaryNarrativeModules;

namespace IMIS.Application.PgsSummaryNarrativeModule
{
    public interface IPGSSummaryNarrativeService : IService
    {
        Task<List<PGSSummaryNarrativeDto>?> GetAllAsync(CancellationToken cancellationToken);       
        Task<PGSSummaryNarrativeDto?> GetByPeriodIdAsync(int pgsPeriodId, CancellationToken cancellationToken);
        Task<List<ReportPGSSummaryNarrativeDto>> ReportGetByFilterAsync(PgsDeliverableSummaryNarrativeFilter filter, CancellationToken cancellationToken);
    }
}
