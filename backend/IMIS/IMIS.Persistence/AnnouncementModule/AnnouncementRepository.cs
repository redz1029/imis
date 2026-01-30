using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AnnouncementModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AnnouncementModule
{
    public class AnnouncementRepository : BaseRepository<Announcement, int, ImisDbContext, User>, IAnnouncementRepository
    {
        public AnnouncementRepository(ImisDbContext dbContext) : base(dbContext)
        {

        }
        public async Task<EntityPageList<Announcement, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<Announcement, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        }
        public async Task<IEnumerable<Announcement>?> FilteByName(string name, int AnnouncementNoOfResults, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(a => EF.Functions.Like(a.Title, $"{name}%"))
                .Take(AnnouncementNoOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
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
        public async Task<IEnumerable<Announcement>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
