﻿using Base.Abstractions;
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
            var pgsdeliverable = await EntityPageList<PgsDeliverable, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
            return pgsdeliverable;
        }
        public new async Task<PgsDeliverable> SaveOrUpdateAsync(PgsDeliverable pgs, CancellationToken cancellationToken)
        {
            if (pgs == null) throw new ArgumentNullException(nameof(pgs));          
            var existingPgs = await _dbContext.Deliverable
                .FirstOrDefaultAsync(d => d.Id == pgs.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingPgs != null)
            {               
                _dbContext.Entry(existingPgs).CurrentValues.SetValues(pgs);
            }
            else
            {             
                await _dbContext.Deliverable.AddAsync(pgs, cancellationToken).ConfigureAwait(false);
            }         
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return pgs;
        }
        async Task<List<PgsDeliverable>?> IPGSDeliverableRepository.GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.Deliverable
          .Where(o => !o.IsDeleted)
          .AsNoTracking()
          .ToListAsync(cancellationToken)
          .ConfigureAwait(false);
        }
    }
}

