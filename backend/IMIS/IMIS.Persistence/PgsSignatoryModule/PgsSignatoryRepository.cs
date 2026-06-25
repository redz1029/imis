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
