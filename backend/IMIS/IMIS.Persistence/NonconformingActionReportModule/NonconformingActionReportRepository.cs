using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.NonconformingActionReportModule
{
    public class NonconformingActionReportRepository : BaseRepository<NonconformingActionReport, long, ImisDbContext, User>, INonconformingActionReportRepository
    {
        public NonconformingActionReportRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<NonconformingActionReport?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<NonconformingActionReport>()
                .Include(x => x.AuditReport)
                .Include(x => x.IssuedByAuditor)
                .Include(x => x.AcknowledgedByAuditee)
                .Include(x => x.ProposedByAuditee)
                .Include(x => x.ApprovedByHead)
                .Include(x => x.VerifiedByAuditor)
                .Include(x => x.ValidatedByLeadAuditor)
                .Include(x => x.RootCauses)
                .Include(x => x.Corrections)
                .Include(x => x.CorrectiveActions)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<NonconformingActionReport, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<NonconformingActionReport, long>.CreateAsync(
                _entities.AsNoTracking()
                    .Include(x => x.AuditReport)
                    .Include(x => x.IssuedByAuditor)
                    .Include(x => x.AcknowledgedByAuditee),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<NonconformingActionReport?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<NonconformingActionReport?> GetByAuditReportIdAsync(int auditReportId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<NonconformingActionReport>()
                .Include(x => x.RootCauses)
                .Include(x => x.Corrections)
                .Include(x => x.CorrectiveActions)
                .FirstOrDefaultAsync(x => x.AuditReportId == auditReportId && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
