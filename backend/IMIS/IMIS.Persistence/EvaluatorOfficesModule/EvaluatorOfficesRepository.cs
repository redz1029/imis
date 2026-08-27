using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.EvaluatorOfficesModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.EvaluatorOfficesModule
{
    public class EvaluatorOfficesRepository : BaseRepository<EvaluatorOffices, int, ImisDbContext, User>, IEvaluatorOfficesRepository
    {
        public EvaluatorOfficesRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<EvaluatorOffices?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<EvaluatorOffices>()
               .Include(e => e.Office)
                .Include(e => e.User)
                .FirstOrDefaultAsync(e => e.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EvaluatorOffices?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<EvaluatorOffices>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<EvaluatorOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .AsNoTracking()
                .Include(e => e.Office)
                .Include(e => e.User);

            return await EntityPageList<EvaluatorOffices, int>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
        }
        public async Task<IEnumerable<EvaluatorOffices>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
        public async Task<IEnumerable<EvaluatorOffices>> GetAllServicesAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(e => e.Office)
                .Include(e => e.User)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<EvaluatorOffices>> GetServicesByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(e => e.Office)
                .Include(e => e.User)
                .Where(e => e.UserId == userId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
