using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapKpiSequenceModule
{
    public interface IKraRoadmapKpiSequenceService : IService
    {
        Task<List<KraRoadmapKpiSequenceDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<KraRoadmapKpiSequenceDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<KraRoadmapKpiSequenceDto, KraRoadmapKpiSequence, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
