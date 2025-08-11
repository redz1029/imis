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
                .Where(a => a.Id != currentAuditId)
                .Where(a => a.OfficeId == officeId) 
                .Where(a => startDate < a.EndDateTime && endDate > a.StartDateTime) 
                .FirstOrDefaultAsync(); 
        }       
    }
}
