using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditProgrammeStatusHistoryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditProgrammeStatusHistoryModule
{
    public class AuditProgrammeStatusHistoryRepository : BaseRepository<AuditProgrammeStatusHistory, int, ImisDbContext, User>, IAuditProgrammeStatusHistoryRepository
    {
        public AuditProgrammeStatusHistoryRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<IEnumerable<AuditProgrammeStatusHistory>> GetByProgrammeIdAsync(int auditProgrammeId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.AuditProgrammeId == auditProgrammeId && !x.IsDeleted)
                .OrderByDescending(x => x.ChangedDate)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<AuditProgrammeStatusHistory, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditProgrammeStatusHistory, int>.CreateAsync(
                _entities.AsNoTracking().Where(x => !x.IsDeleted).OrderByDescending(x => x.ChangedDate),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditProgrammeStatusHistory?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}