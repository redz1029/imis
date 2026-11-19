using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PolicyAndProcedureSectionNumberingModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PolicyAndProcedureSectionNumberingModule
{
    public class PolicyAndProcedureSectionNumberingRepository : BaseRepository<PolicyAndProcedureSectionNumbering, int, ImisDbContext, User>, IPolicyAndProcedureSectionNumberingRepository
    {
        public PolicyAndProcedureSectionNumberingRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<EntityPageList<PolicyAndProcedureSectionNumbering, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<PolicyAndProcedureSectionNumbering, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<IEnumerable<PolicyAndProcedureSectionNumbering>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
        public async Task<PolicyAndProcedureSectionNumbering?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PolicyAndProcedureSectionNumbering>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

    }
}
