using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPerfomanceGovernanceSystemRepository : IRepository<PerfomanceGovernanceSystem, long>
    {
        Task<PerfomanceGovernanceSystem?> GetByUserIdAndPgsIdAsync(string userId, int pgsId, CancellationToken cancellationToken);
        Task<IEnumerable<PerfomanceGovernanceSystem>> GetAll(CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystem?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystem?> ReportGetByIdAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<PerfomanceGovernanceSystem>> GetByUserIdAsync(string userid, CancellationToken cancellationToken);
        Task<IEnumerable<PerfomanceGovernanceSystem>> GetAllAsyncFilterByPgsPeriod(long? pgsPeriodId, CancellationToken cancellationToken);
        Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedPgsPeriodIdAsync(long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken);
        Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetFilteredPGSAsync(PgsFilter filter, string userId, CancellationToken cancellationToken);
    }
}
