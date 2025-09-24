using Base.Abstractions;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentRepository(ImisDbContext dbContext)
    : BaseRepository<PgsDeliverableAccomplishment, long, ImisDbContext>(dbContext), IPgsDeliverableAccomplishmentRepository
    {
        public async Task<List<PgsDeliverableAccomplishment>> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken)
        {
            return await _entities
            .Where(a => a.PgsDeliverableId == deliverableId)
            .Include(a => a.User)
            .ToListAsync(cancellationToken);
        }
    }
}
