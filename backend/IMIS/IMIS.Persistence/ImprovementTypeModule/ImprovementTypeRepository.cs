using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.ImprovementTypeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.ImprovementTypeModule
{
    public class ImprovementTypeRepository : BaseRepository<ImprovementType, int, ImisDbContext, User>, IImprovementTypeRepository
    {
        public ImprovementTypeRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<EntityPageList<ImprovementType, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<ImprovementType, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<ImprovementType>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
