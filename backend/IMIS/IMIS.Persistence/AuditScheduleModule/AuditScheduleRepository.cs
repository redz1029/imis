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
        public async Task<EntityPageList<AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditSchedule, int>
             .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
             .ConfigureAwait(false);
        }

        public async Task<AuditScheduleDetails?> GetOverlappingAuditAsync(int officeId, DateTime startDateTime, DateTime endDateTime, int id)
        {
             return await ReadOnlyDbContext.Set<AuditScheduleDetails>()
            .Where(a => a.Id != id) 
            .Where(a => a.OfficeId == officeId) 
            .Where(a => startDateTime < a.EndDateTime && endDateTime > a.StartDateTime)
            .FirstOrDefaultAsync(); 
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
        public new async Task<AuditSchedule> SaveOrUpdateAsync(AuditSchedule auditSchedule, CancellationToken cancellationToken)
        {
            if (auditSchedule == null) throw new ArgumentNullException(nameof(auditSchedule));

            var existingAudit = await _entities   
                .FirstOrDefaultAsync(d => d.Id == auditSchedule.Id, cancellationToken);

            if (existingAudit != null)
            {
                // Update only changed fields
                _dbContext.Entry(existingAudit).CurrentValues.SetValues(auditSchedule);
            }
            else
            {
                // Add new audit schedule
                await _entities.AddAsync(auditSchedule, cancellationToken);
            }
            await _dbContext.SaveChangesAsync(cancellationToken);
            return auditSchedule;
        }
    }
}
