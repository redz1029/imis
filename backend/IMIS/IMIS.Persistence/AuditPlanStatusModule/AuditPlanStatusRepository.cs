using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanStatusModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;


namespace IMIS.Persistence.AuditPlanStatusModule
{
    public class AuditPlanStatusRepository : BaseRepository<AuditPlanStatus, int, ImisDbContext, User>, IAuditPlanStatusRepository
    {
        public AuditPlanStatusRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<EntityPageList<AuditPlanStatus, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditPlanStatus, int>.CreateAsync(
                _entities.AsNoTracking(),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanStatus>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}