using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.OfficeTypeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.OfficeTypeModule
{
    public class OfficeTypeRepository : BaseRepository<OfficeType, int, ImisDbContext>, IOfficeTypeRepository
    {
        public OfficeTypeRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<EntityPageList<OfficeType, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<OfficeType, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        }
        public async Task<IEnumerable<OfficeType>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }       
    }
}
