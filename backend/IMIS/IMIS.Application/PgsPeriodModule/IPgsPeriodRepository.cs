using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsPeriodModule
{
    public interface IPgsPeriodRepository : IRepository<PgsPeriod, int>
    {
        Task<EntityPageList<PgsPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<PgsPeriod>> GetAll(CancellationToken cancellationToken);     
        //new Task<PgsPeriod> SaveOrUpdateAsync(PgsPeriod period, CancellationToken cancellationToken);
    }
}


