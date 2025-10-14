using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsSummaryNarrativeModules;
using IMIS.Domain;

namespace IMIS.Application.PgsSummaryNarrativeModule
{
    public interface IPGSSummaryNarrativeService : IService
    {
        Task<List<PGSSummaryNarrativeDto>?> GetAllAsync(CancellationToken cancellationToken);       
        Task<PGSSummaryNarrativeDto?> GetByPeriodIdAsync(int pgsPeriodId, CancellationToken cancellationToken);       
        Task<List<ReportPGSSummaryNarrativeDto>> ReportGetByFilterAsync(PgsDeliverableSummaryNarrativeFilter filter, CancellationToken cancellationToken);
        Task<DtoPageList<PGSSummaryNarrativeDto, PgsSummaryNarrative, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<PGSSummaryNarrativeDto>> GetNarrativesForAuditorAsync(int? periodId, int? office, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<PGSSummaryNarrativeDto>> GetNarrativesForHeadAuditorAsync(int? periodId, int? office, CancellationToken cancellationToken);
        Task<PGSSummaryNarrativeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
    }
}
