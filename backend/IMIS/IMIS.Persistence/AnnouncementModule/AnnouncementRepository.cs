using Base.Abstractions;
using IMIS.Application.AnnouncementModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AnnouncementModule
{
    public class AnnouncementRepository : BaseRepository<Announcement, int, ImisDbContext>, IAnnouncementRepository
    {
        public AnnouncementRepository(ImisDbContext dbContext) : base(dbContext)
        {

        }
        public async Task<Announcement?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<Announcement>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<Announcement>?> GetAllActive(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(a => a.IsActive)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
