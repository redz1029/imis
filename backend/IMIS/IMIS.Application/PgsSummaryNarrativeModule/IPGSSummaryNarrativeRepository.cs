using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsSummaryNarrativeModule
{
    public interface IPGSSummaryNarrativeRepository : IRepository<PgsSummaryNarrative, int>
    {
        Task<IEnumerable<PgsSummaryNarrative>> GetAll(CancellationToken cancellationToken);
        Task<PgsSummaryNarrative?> GetByPeriodIdAsync(int pgsPeriodId, CancellationToken cancellationToken);
        Task<List<PgsSummaryNarrative>> GetNarrativesByFilterAsync(PgsDeliverableSummaryNarrativeFilter filter, CancellationToken cancellationToken);
        Task<List<PgsDeliverable>> GetFilteredDeliverablesAsync(IEnumerable<int> periodIds, PgsDeliverableSummaryNarrativeFilter filter, CancellationToken cancellationToken);
        Task<EntityPageList<PgsSummaryNarrative, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<PgsSummaryNarrative>> GetNarrativesByAuditorAsync(string userid, int? office, int? periodId, CancellationToken cancellationToken);
        Task<PgsSummaryNarrative?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<PgsSummaryNarrative>> GetAllForAuditorHeadAsync(int? periodId, int? office, CancellationToken cancellationToken);
        Task<IEnumerable<PgsSummaryNarrative>> GetAllFilteredNarrativeForHeadsAsync(int? periodId, int? office, CancellationToken cancellationToken);
    }
}
