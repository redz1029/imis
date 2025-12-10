using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapPeriodModule
{
    public interface IKraRoadMapPeriodService : IService
    {
        Task<List<KraRoadMapPeriodDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<KraRoadMapPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<KraRoadMapPeriodDto, KraRoadMapPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
