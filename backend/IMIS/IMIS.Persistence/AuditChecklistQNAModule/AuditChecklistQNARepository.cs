using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditChecklistQNAModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditChecklistQNAModule
{
    public class AuditChecklistQNARepository : BaseRepository<AuditChecklistQNA, int, ImisDbContext, User>, IAuditChecklistQNARepository
    {
        public AuditChecklistQNARepository(ImisDbContext dbContext) : base(dbContext) { }

        /// <summary>
        /// Retrieves all Questions and Answers for a specific checklist.
        /// Useful for loading the QNA section of a specific audit form.
        /// </summary>
        public async Task<IEnumerable<AuditChecklistQNA>> GetByChecklistIdAsync(int checklistId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.IsoStandardId == checklistId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        /// <summary>
        /// Paginated retrieval of QNA items. 
        /// Use AsNoTracking for performance in read-only list views.
        /// </summary>
        public async Task<EntityPageList<AuditChecklistQNA, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditChecklistQNA, int>.CreateAsync(
                _entities.AsNoTracking(),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        /// <summary>
        /// Overriding the base GetById to ensure we have a clean implementation 
        /// if specific includes are needed later.
        /// </summary>
        public override async Task<AuditChecklistQNA?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditChecklistQNA>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}