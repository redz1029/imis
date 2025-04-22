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
            var query = _dbContext.AuditSchedules
                .Where(k => !k.IsDeleted)
                .AsNoTracking();

            var auditSchedules = await EntityPageList<AuditSchedule, int>
             .CreateAsync(query, page, pageSize, cancellationToken)
             .ConfigureAwait(false);
            return auditSchedules;
        }
        // Check Overlapping in AuditScheduleDetails
        public async Task<AuditScheduleDetails?> GetOverlappingAuditAsync(int officeId, DateTime startDateTime, DateTime endDateTime, int id)
        {
             return await _dbContext.AuditScheduleDetails
            .Where(a => a.Id != id) 
            .Where(a => a.OfficeId == officeId) 
            .Where(a => startDateTime < a.EndDateTime && endDateTime > a.StartDateTime)
            .FirstOrDefaultAsync(); 
        }
        public async Task AddAuditableOfficesAsync(List<AuditableOffices> auditableOffices, CancellationToken cancellationToken)
        {
            var existingOfficeIds = _dbContext.AuditableOffices
                .Where(a => auditableOffices.Select(o => o.OfficeId).Contains(a.OfficeId))
                .Select(a => a.OfficeId)
                .ToList();

            var newOffices = auditableOffices.Where(o => !existingOfficeIds.Contains(o.OfficeId)).ToList();

            if (newOffices.Any())
            {
                await _dbContext.AuditableOffices.AddRangeAsync(newOffices, cancellationToken);
                await _dbContext.SaveChangesAsync(cancellationToken);
            }
        }       
        public async Task<IEnumerable<AuditSchedule>> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.AuditSchedules
                .Where(a => !a.IsDeleted)
                .ToListAsync(cancellationToken);
        }

       
        public async Task<IEnumerable<AuditSchedule>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.AuditSchedules
                .Where(a => a.IsActive && !a.IsDeleted)
                .ToListAsync(cancellationToken);
        }

        // Save or Update an Audit Schedule
        public new async Task<AuditSchedule> SaveOrUpdateAsync(AuditSchedule auditSchedule, CancellationToken cancellationToken)
        {
            if (auditSchedule == null) throw new ArgumentNullException(nameof(auditSchedule));

            var existingAudit = await _dbContext.AuditSchedules
                .FirstOrDefaultAsync(d => d.Id == auditSchedule.Id, cancellationToken);

            if (existingAudit != null)
            {
                // Update only changed fields
                _dbContext.Entry(existingAudit).CurrentValues.SetValues(auditSchedule);
            }
            else
            {
                // Add new audit schedule
                await _dbContext.AuditSchedules.AddAsync(auditSchedule, cancellationToken);
            }

            await _dbContext.SaveChangesAsync(cancellationToken);
            return auditSchedule;
        }
    }
}
