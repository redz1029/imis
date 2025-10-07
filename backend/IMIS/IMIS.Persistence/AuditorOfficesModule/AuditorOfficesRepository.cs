using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditorOfficesModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditorOfficesModule
{
    public class AuditorOfficesRepository (ImisDbContext dbContext) : BaseRepository<AuditorOffices, int, ImisDbContext>(dbContext), IAuditorOfficesRepository
    {
        public async Task<EntityPageList<AuditorOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditorOffices, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        }
        public async Task<AuditorOffices?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditorOffices>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<AuditorOffices>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
