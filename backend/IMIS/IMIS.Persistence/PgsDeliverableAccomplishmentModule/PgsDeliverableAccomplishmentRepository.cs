using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentRepository(ImisDbContext dbContext)
    : BaseRepository<PgsDeliverableAccomplishment, long, ImisDbContext, User>(dbContext), IPgsDeliverableAccomplishmentRepository
    {
        public async Task<EntityPageList<PgsDeliverableAccomplishment, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<PgsDeliverableAccomplishment, long>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        }
        public async Task<int> GetAttachmentCountByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.PgsDeliverableId == deliverableId && !string.IsNullOrWhiteSpace(x.AttachmentPath))
                .CountAsync(cancellationToken);
        }
        public async Task<List<PgsDeliverableAccomplishment>> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken)
        {
            return await _entities
            .Where(a => a.PgsDeliverableId == deliverableId)
            .Include(a => a.User)
            .ToListAsync(cancellationToken);
        }
    }
}
