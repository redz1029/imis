using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsPeriodModule
{
    public interface IPgsPeriodService : IService
    {
        public Task<DtoPageList<PgsPeriodDto, PgsPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<PgsPeriodDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PgsPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
    }
}
