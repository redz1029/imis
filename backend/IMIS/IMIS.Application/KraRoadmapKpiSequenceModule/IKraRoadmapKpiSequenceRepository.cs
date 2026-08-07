using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapKpiSequenceModule
{
    public interface IKraRoadmapKpiSequenceRepository : IRepository<KraRoadmapKpiSequence, int>
    {
        Task<KraRoadmapKpiSequence?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<KraRoadmapKpiSequence>> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<KraRoadmapKpiSequence, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
