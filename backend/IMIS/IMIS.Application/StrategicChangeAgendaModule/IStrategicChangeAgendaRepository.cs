using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.StrategicChangeAgendaModule
{
    public interface IStrategicChangeAgendaRepository : IRepository<StrategicChangeAgenda, long>
    {
        Task<StrategicChangeAgenda?> GetByIdWithChildrenAsync(long id, CancellationToken cancellationToken);
        Task<EntityPageList<StrategicChangeAgenda, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<StrategicChangeAgenda?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
