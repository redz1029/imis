using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.StrategicChangeAgendaModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.StrategicChangeAgendaModule
{
    public class StrategicChangeAgendaRepository : BaseRepository<StrategicChangeAgenda, long, ImisDbContext, User>, IStrategicChangeAgendaRepository
    {
        public StrategicChangeAgendaRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<StrategicChangeAgenda?> GetByIdWithChildrenAsync(long id, CancellationToken cancellationToken)
        {
                 return await ReadOnlyDbContext.Set<StrategicChangeAgenda>()
                .Include(x => x.StrategicChangeAgendaDeliverable)
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);
        }
        public async Task<StrategicChangeAgenda?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {

            return await _entities.FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<EntityPageList<StrategicChangeAgenda, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<StrategicChangeAgenda, long>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
    }
}
