using Base.Abstractions;
using IMIS.Application.AuditScheduleModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditScheduleModule
{

    public class AuditScheduleDetailRepository(ImisDbContext dbContext) : BaseRepository<AuditScheduleDetails, int, ImisDbContext>(dbContext), IAuditScheduleDetailRepository
    {    
        public async Task<AuditScheduleDetails?> GetOverlappingAuditAsync(int officeId, DateTime startDate, DateTime endDate, int currentAuditId)
        {
            return await _entities
                .Where(a => a.AuditScheduleId != currentAuditId) 
                .Where(a => a.OfficeId == officeId)
                .Where(a => startDate <= a.EndDateTime && endDate >= a.StartDateTime)
                .FirstOrDefaultAsync();
        }
        public async Task<AuditScheduleDetails?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditScheduleDetails>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
    }
}
