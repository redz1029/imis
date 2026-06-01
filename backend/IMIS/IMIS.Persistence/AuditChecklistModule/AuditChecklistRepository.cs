using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditChecklistModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditChecklistModule
{
    public class AuditChecklistRepository : BaseRepository<AuditChecklist, int, ImisDbContext, User>, IAuditChecklistRepository
    {
        public AuditChecklistRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<AuditChecklist?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditChecklist>()
                .Include(x => x.Auditor)
                .Include(x => x.AuditChecklistQNA) // Navigation property from your new domain
                .Include(x => x.QnA)               // Required navigation property from your new domain
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditChecklist>> GetByQnAIdAsync(int qnaId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                // Filtering by the QNA relationship as per your new domain structure
                .Where(x => x.AuditChecklistQNA != null && x.AuditChecklistQNA.Id == qnaId)
                .Include(x => x.Auditor)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditChecklist, int>.CreateAsync(
                _entities.AsNoTracking()
                    .Include(x => x.AuditChecklistQNA)
                    .Include(x => x.Auditor),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditChecklist?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken)
        {
            // Fecthing with tracking enabled so the context can handle the Soft Delete update
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditChecklist>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.Auditor)
                .Include(x => x.AuditChecklistQNA)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}