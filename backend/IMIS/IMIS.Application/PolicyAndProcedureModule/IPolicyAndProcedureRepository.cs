using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureModule
{
    public interface IPolicyAndProcedureRepository : IRepository<PolicyAndProcedure, long>
    {
        Task<PolicyAndProcedure?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<PolicyAndProcedure, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
