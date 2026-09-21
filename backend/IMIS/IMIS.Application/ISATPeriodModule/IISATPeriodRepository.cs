using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IndividualStrategicAlignmentTreePeriodModule
{
    public interface IISATPeriodRepository : IRepository<ISATPeriod, int>
    {
        Task<IEnumerable<ISATPeriod>> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<ISATPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<ISATPeriod?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
