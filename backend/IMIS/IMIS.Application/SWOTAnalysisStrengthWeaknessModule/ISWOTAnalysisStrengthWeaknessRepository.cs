using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisStrengthWeaknessModule
{
    public interface ISWOTAnalysisStrengthWeaknessRepository : IRepository<SWOTAnalysisStrengthWeakness, int>
    {
        Task<EntityPageList<SWOTAnalysisStrengthWeakness, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<SWOTAnalysisStrengthWeakness>> GetAll(CancellationToken cancellationToken);
        Task<SWOTAnalysisStrengthWeakness?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
