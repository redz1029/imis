using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureSectionNumberingModule
{
    public interface IPolicyAndProcedureSectionNumberingRepository : IRepository<PolicyAndProcedureSectionNumbering, int>
    {
        Task<IEnumerable<PolicyAndProcedureSectionNumbering>> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<PolicyAndProcedureSectionNumbering, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PolicyAndProcedureSectionNumbering?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
