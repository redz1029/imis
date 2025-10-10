using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditScheduleModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditScheduleModule
{
    public class AuditScheduleRepository(ImisDbContext dbContext)
        : BaseRepository<AuditSchedule, int, ImisDbContext>(dbContext), IAuditScheduleRepository
    {

        public async Task<AuditSchedule?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditSchedule>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditSchedule, int>
             .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
             .ConfigureAwait(false);
        }
        public async Task<AuditSchedule?> GetByAuditScheduleIdAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditSchedule>()
                .Include(a => a.AuditableOffices)
                .Include(a => a.AuditSchduleDetails)
                .FirstOrDefaultAsync(a => a.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task AddAuditableOfficesAsync(List<AuditableOffices> auditableOffices, CancellationToken cancellationToken)
        {
            var existingOfficeIds = ReadOnlyDbContext.Set<AuditableOffices>()
                .Where(a => auditableOffices.Select(o => o.OfficeId).Contains(a.OfficeId))
                .Select(a => a.OfficeId)
                .ToList();

            var newOffices = auditableOffices.Where(o => !existingOfficeIds.Contains(o.OfficeId)).ToList();

            if (newOffices.Any())
            {
                await ReadOnlyDbContext.Set<AuditableOffices>().AddRangeAsync(newOffices, cancellationToken);
                await GetDbContext().SaveChangesAsync(cancellationToken);
            }
        }
        
        public async Task<IEnumerable<AuditSchedule>> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .ToListAsync(cancellationToken);
        }
        public async Task<IEnumerable<AuditSchedule>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .Where(a => a.IsActive)
                .Include(a => a.AuditableOffices)
                .Include(a => a.AuditSchduleDetails)
                .ToListAsync(cancellationToken);
        }        
    }
}
