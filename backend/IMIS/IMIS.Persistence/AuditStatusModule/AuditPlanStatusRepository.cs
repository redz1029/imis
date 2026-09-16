using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditStatusModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditStatusModule
{
    public class AuditPlanStatusRepository : BaseRepository<AuditPlanStatus, int, ImisDbContext, User>, IAuditPlanStatusRepository
    {
        public AuditPlanStatusRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<IEnumerable<AuditPlanStatus>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => !x.IsDeleted)
                .OrderBy(x => x.SortOrder)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<AuditPlanStatus, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditPlanStatus, int>.CreateAsync(
                _entities.AsNoTracking().Where(x => !x.IsDeleted).OrderBy(x => x.SortOrder),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditPlanStatus?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<bool> IsInUseAsync(int id, CancellationToken cancellationToken)
        {
            var dbContext = GetDbContext();

            var inProgramme = await dbContext.Set<AuditProgramme>()
                .AnyAsync(x => x.AuditStatusId == id && !x.IsDeleted, cancellationToken);
            if (inProgramme) return true;

            // Uncomment once AuditPlan carries AuditStatusId:
            // var inPlan = await dbContext.Set<AuditPlan>()
            //     .AnyAsync(x => x.AuditStatusId == id && !x.IsDeleted, cancellationToken);
            // if (inPlan) return true;

            return false;
        }
    }
}