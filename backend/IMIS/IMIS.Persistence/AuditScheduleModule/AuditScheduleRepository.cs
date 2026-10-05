using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditScheduleModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditScheduleModule
{
    public class AuditScheduleRepository : BaseRepository<AuditSchedule, int, ImisDbContext, User>, IAuditScheduleRepository
    {
        public AuditScheduleRepository(ImisDbContext dbContext) : base(dbContext) { }

        private static IQueryable<AuditSchedule> WithSignatories(IQueryable<AuditSchedule> query) => query
            .Include(x => x.IQASignatories.Where(s => !s.IsDeleted))
                .ThenInclude(s => s.Signatory)
            .Include(x => x.IQASignatories.Where(s => !s.IsDeleted))
                .ThenInclude(s => s.IQASignatoryTemplate)
            .Include(x => x.ApprovalHistories.Where(h => !h.IsDeleted))
                .ThenInclude(h => h.User)
            .Include(x => x.AuditableOffices!.Where(ao => !ao.IsDeleted))
                .ThenInclude(ao => ao.Office);

        // --- Main entity retrieval ---
        public async Task<AuditSchedule?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            return await WithSignatories(ReadOnlyDbContext.Set<AuditSchedule>())
                .Include(x => x.Team)
                .Include(x => x.AuditSchduleDetails)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<AuditSchedule?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await WithSignatories(ReadOnlyDbContext.Set<AuditSchedule>())
                .Include(x => x.Team)
                .Include(x => x.AuditSchduleDetails)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<AuditSchedule?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditSchedule>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditSchedule>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await WithSignatories(_entities)
                .Include(x => x.Team)
                .Include(x => x.AuditSchduleDetails)
                .ToListAsync(cancellationToken);
        }

        public async Task<EntityPageList<AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditSchedule, int>
                .CreateAsync(WithSignatories(_entities.AsNoTracking()), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Child helpers ---
        public async Task<List<int>> GetExistingAuditableOfficeIdsAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == auditScheduleId)
                .SelectMany(x => x.AuditableOffices.Select(o => o.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task<List<int>> GetExistingAuditScheduleDetailsIdsAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == auditScheduleId)
                .SelectMany(x => x.AuditSchduleDetails.Select(d => d.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task AddAuditableOfficesAsync(List<AuditableOffices> offices, CancellationToken cancellationToken)
        {
            var context = GetDbContext();
            await context.Set<AuditableOffices>().AddRangeAsync(offices, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
        }

        public async Task AddAuditScheduleDetailsAsync(List<AuditScheduleDetails> details, CancellationToken cancellationToken)
        {
            var context = GetDbContext();
            await context.Set<AuditScheduleDetails>().AddRangeAsync(details, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditSchedule>> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            return await WithSignatories(_entities)
                .Where(x => x.AuditPlanId == auditPlanId && !x.IsDeleted)
                .Include(x => x.Team)
                .Include(x => x.AuditSchduleDetails)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditSchedule>> GetByAuditPlanEntryIdAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            return await WithSignatories(_entities)
                .Where(x => x.AuditPlanEntryId == auditPlanEntryId && !x.IsDeleted)
                .Include(x => x.Team)
                .Include(x => x.AuditSchduleDetails)
                .ToListAsync(cancellationToken);
        }
    }
}