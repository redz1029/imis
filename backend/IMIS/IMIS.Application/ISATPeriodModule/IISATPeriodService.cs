using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Application.IndividualStrategicAlignmentTreePeriodModule
{
    public interface IISATPeriodService : IService
    {
        Task<List<ISATPeriodDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<ISATPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<ISATPeriodDto, ISATPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
