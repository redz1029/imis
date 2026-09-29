using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.NcarMonitoringLogModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.NcarMonitoringLogModule
{
    public class NcarMonitoringLogRepository : BaseRepository<NcarMonitoringLog, long, ImisDbContext, User>, INcarMonitoringLogRepository
    {
        public NcarMonitoringLogRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<NcarMonitoringLog?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<NcarMonitoringLog>()
                .Include(x => x.NonconformingActionReport)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<NcarMonitoringLog, long>> GetPaginatedSortedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var slaCutoff = DateTime.UtcNow.AddDays(-5);

            var query = _entities.AsNoTracking()
                .OrderByDescending(x => x.Remarks == "Active" && x.DateIssued < slaCutoff) // Overdue first
                .ThenBy(x => x.Remarks == "Active" ? x.DateIssued : DateTime.MaxValue) // Pending ascending
                .ThenByDescending(x => x.DateValidated); // Closed by validated date desc

            return await EntityPageList<NcarMonitoringLog, long>.CreateAsync(query, page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<NcarMonitoringLog?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<NcarMonitoringLog?> GetByNonconformingActionReportIdAsync(long ncarId, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.NonconformingActionReportId == ncarId && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<int> GetNextSequenceAsync(int issuedYear, CancellationToken cancellationToken)
        {
            var maxSequence = await ReadOnlyDbContext.Set<NcarMonitoringLog>()
                .Where(x => x.IssuedYear == issuedYear)
                .Select(x => (int?)x.SequenceNo)
                .MaxAsync(cancellationToken)
                .ConfigureAwait(false);

            return (maxSequence ?? 0) + 1;
        }
    }
}
