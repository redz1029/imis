using Base.Abstractions;
using IMIS.Application.AuditScheduleModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditScheduleModule
{

    public class AuditScheduleDetailRepository(ImisDbContext dbContext) : BaseRepository<AuditScheduleDetails, int, ImisDbContext>(dbContext), IAuditScheduleDetailRepository
    {
      
        public new async Task<AuditScheduleDetails> SaveOrUpdateAsync(AuditScheduleDetails AuditDetails, CancellationToken cancellationToken)
        {
            if (AuditDetails == null) throw new ArgumentNullException(nameof(AuditDetails));
            // Check if the entity already exists
            var existingAuditDetails = await _dbContext.AuditScheduleDetails
                .FirstOrDefaultAsync(d => d.Id == AuditDetails.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingAuditDetails != null)
            {
                // Update existing entity
                _dbContext.Entry(existingAuditDetails).CurrentValues.SetValues(AuditDetails);
            }
            else
            {
                // Add new entity
                await _dbContext.AuditScheduleDetails.AddAsync(AuditDetails, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return AuditDetails;
        }
    }




}
