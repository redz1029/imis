using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureModule
{
    public interface IPolicyAndProcedureRepository : IRepository<PolicyAndProcedure, long>
    {
        Task<List<PolicyAndProcedureSignatory>> GetByPgsIdForSoftDeleteAsync(long pgsid, CancellationToken cancellationToken);
        Task<PolicyAndProcedure?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<PolicyAndProcedure, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PolicyAndProcedure?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<PolicyAndProcedure?> GetWithIncludesAsync(long id, CancellationToken cancellationToken);
        Task<List<PolicyAndProcedure>> GetFilteredCandidatesAsync(PolicyAndProcedureFilter filter, string userId, bool viewAll, bool includeChildOffices, CancellationToken cancellationToken);
    }
}
