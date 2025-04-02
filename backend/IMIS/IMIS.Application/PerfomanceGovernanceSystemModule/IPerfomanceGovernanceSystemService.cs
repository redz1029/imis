using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;
using static IMIS.Application.PgsModule.PerfomanceGovernanceSystemDto;

namespace IMIS.Application.PgsModule
{
    public interface IPerfomanceGovernanceSystemService : IService
    {
        public Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystemDto> SaveOrUpdateAsync(PerfomanceGovernanceSystemDto perfomanceGovernanceSystemDto, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystemDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystemDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
    }
}
