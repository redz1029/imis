using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PolicyAndProcedureModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PolicyAndProcedureModule
{
    public class PolicyAndProcedureRepository : BaseRepository<PolicyAndProcedure, long, ImisDbContext, User>, IPolicyAndProcedureRepository
    {
        public PolicyAndProcedureRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<PolicyAndProcedure?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(p => p.Section)
                .FirstOrDefaultAsync(p => p.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<PolicyAndProcedure?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PolicyAndProcedure>().FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<PolicyAndProcedure, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<PolicyAndProcedure, long>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
    }
}
