using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PGSModules
{   
    public class PGSDeliverableRepository(ImisDbContext dbContext)
    : BaseRepository<PgsDeliverable, long, ImisDbContext>(dbContext), IPGSDeliverableRepository
    {

        public async Task<EntityPageList<PgsDeliverable, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _dbContext.Deliverable.Where(k => !k.IsDeleted).AsNoTracking();
            var pgsDeliverable = await EntityPageList<PgsDeliverable, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
            return pgsDeliverable;
        }
        public new async Task<PgsDeliverable> SaveOrUpdateAsync(PgsDeliverable pgsDeliverable, CancellationToken cancellationToken)
        {
            if (pgsDeliverable == null) throw new ArgumentNullException(nameof(pgsDeliverable));          
            var existingPgsDeliverable = await _dbContext.Deliverable
                .FirstOrDefaultAsync(d => d.Id == pgsDeliverable.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingPgsDeliverable != null)
            {               
                _dbContext.Entry(existingPgsDeliverable).CurrentValues.SetValues(pgsDeliverable);
            }
            else
            {             
                await _dbContext.Deliverable.AddAsync(pgsDeliverable, cancellationToken).ConfigureAwait(false);
            }         
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return pgsDeliverable;
        }
        async Task<List<PgsDeliverable>?> IPGSDeliverableRepository.GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.Deliverable
          .Where(o => !o.IsDeleted)
          .Include(o => o.Kra)
          .AsNoTracking()
          .ToListAsync(cancellationToken)
          .ConfigureAwait(false);
        }
    }
}

