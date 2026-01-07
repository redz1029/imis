using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.OfficeModule;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapModule
{
    public interface IKraRoadMapService : IService
    {
        public Task<DtoPageList<KraRoadMapDto, KraRoadMap, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<KraRoadMapDto>?> GetAll(CancellationToken cancellationToken);
        Task<KraRoadMapDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<KraRoadMapFilter>>GetFilteredDeliverablesAsync(int kraId, int year, string kraDescription, bool isDirect, CancellationToken cancellationToken);
        Task<IEnumerable<KraRoadMapDescriptionFilter>> GetAllKraDescriptionsByKraIdAsync(int kraId, CancellationToken cancellationToken);
        Task<ReportKraRoadMapDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<KraRoadMapDto>> GetAllRoadmapForUserAsync(CancellationToken cancellationToken);
    }
}
