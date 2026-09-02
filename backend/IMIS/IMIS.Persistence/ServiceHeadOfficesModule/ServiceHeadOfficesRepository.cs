using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.ServiceHeadOfficesModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.ServiceHeadOfficesModule
{
    public class ServiceHeadOfficesRepository : BaseRepository<ServiceHeadOffices, int, ImisDbContext, User>, IServiceHeadOfficesRepository
    {
        public ServiceHeadOfficesRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<ServiceHeadOffices?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<ServiceHeadOffices>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<ServiceHeadOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .AsNoTracking()
                .Include(e => e.Office)
                .Include(e => e.User);

            return await EntityPageList<ServiceHeadOffices, int>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
        }
        public async Task<IEnumerable<ServiceHeadOffices>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .Include(e => e.Office)
            .Include(e => e.User)
            .AsNoTracking()            
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
        public async Task<ServiceHeadOffices?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<ServiceHeadOffices>()
               .Include(e => e.Office)
                .Include(e => e.User)
                .FirstOrDefaultAsync(e => e.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
