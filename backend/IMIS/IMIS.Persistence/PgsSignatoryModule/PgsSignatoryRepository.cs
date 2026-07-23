using Base.Abstractions;
using IMIS.Application.PgsSignatoryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsSignatoryModule
{
    public class PgsSignatoryRepository : BaseRepository<PgsSignatory, long, ImisDbContext, User>, IPgsSignatoryRepository
    {
        public PgsSignatoryRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<List<PgsSignatory>> GetByPgsIdForSoftDeleteAsync(int pgsId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PgsSignatory>()
                .Where(x => x.PgsId == pgsId && !x.IsDeleted)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<PgsSignatory>?> GetAllPgsSignatoryId(long? pgsSignatoryId, CancellationToken cancellationToken)
        {
            var query = _entities.AsNoTracking().AsQueryable();

            if (pgsSignatoryId.HasValue)
            {
                query = query.Where(x => x.PgsId == pgsSignatoryId);
            }
            return await query.ToListAsync(cancellationToken).ConfigureAwait(false);
        }
    }
}
