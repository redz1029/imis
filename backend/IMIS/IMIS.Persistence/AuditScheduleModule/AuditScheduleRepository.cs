using Base.Abstractions;
using IMIS.Application.AuditScheduleModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditScheduleModule
{
    public class AuditScheduleRepository(ImisDbContext dbContext) : BaseRepository<AuditSchedule, int, ImisDbContext>(dbContext), IAuditScheduleRepository
    {

        public async Task<AuditSchedule?> GetOverlappingAuditAsync(int officeId, DateTime startDate, DateTime endDate, int currentAuditId)
        {
            return await _dbContext.AuditSchedules
            .Where(a => a.Id != currentAuditId) // Exclude current audit if updating
            .Where(a => a.AuditSchduleDetails!.Any(o => o.OfficeId == officeId)) // Check same office
            .Where(a => startDate < a.EndDate && endDate > a.StartDate) //Check overlapping dates
            .FirstOrDefaultAsync();
        }

        public async Task AddAuditableOfficesAsync(List<AuditableOffices> auditableOffices, CancellationToken cancellationToken)
        {
            await _dbContext.AuditableOffices.AddRangeAsync(auditableOffices, cancellationToken);
            await _dbContext.SaveChangesAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditSchedule>> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.AuditSchedules
            .Where(a => !a.IsDeleted)
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
        public async Task<IEnumerable<AuditSchedule>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.AuditSchedules
            .Where(a => a.IsActive && !a.IsDeleted)
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
     
        public new async Task<AuditSchedule> SaveOrUpdateAsync(AuditSchedule auditSchedule, CancellationToken cancellationToken)
        {
            if (auditSchedule == null) throw new ArgumentNullException(nameof(auditSchedule));
            // Check if the entity already exists
            var existingAuditDetails = await _dbContext.AuditSchedules
                .FirstOrDefaultAsync(d => d.Id == auditSchedule.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingAuditDetails != null)
            {
                // Update existing entity
                _dbContext.Entry(existingAuditDetails).CurrentValues.SetValues(auditSchedule);
            }
            else
            {
                // Add new entity
                await _dbContext.AuditSchedules.AddAsync(auditSchedule, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return auditSchedule;
        }
    }
}
