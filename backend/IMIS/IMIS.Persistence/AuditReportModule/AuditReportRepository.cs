using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditReportModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditReportModule
{
    public class AuditReportRepository : BaseRepository<AuditReport, int, ImisDbContext, User>, IAuditReportRepository
    {
        public AuditReportRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<AuditReport?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditReport>()
                .Include(x => x.OfficeAudited)
                .Include(x => x.AuditStandardISO)
                .Include(x => x.DateofAudit)
                .Include(x => x.AuditComFindings)
                .Include(x => x.AuditScope)
                .Include(x => x.AuditSummaryFIndings)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<AuditReport, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditReport, int>.CreateAsync(
                _entities.AsNoTracking()
                    .Include(x => x.OfficeAudited)
                    .Include(x => x.AuditStandardISO)
                    .Include(x => x.DateofAudit),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditReport?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}