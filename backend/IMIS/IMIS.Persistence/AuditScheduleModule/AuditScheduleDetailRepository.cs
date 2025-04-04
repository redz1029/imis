﻿using Base.Abstractions;
using IMIS.Application.AuditScheduleModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditScheduleModule
{

    public class AuditScheduleDetailRepository(ImisDbContext dbContext) : BaseRepository<AuditScheduleDetails, int, ImisDbContext>(dbContext), IAuditScheduleDetailRepository
    {
      
        public new async Task<AuditScheduleDetails> SaveOrUpdateAsync(AuditScheduleDetails auditScheduleDetails, CancellationToken cancellationToken)
        {
            if (auditScheduleDetails == null) throw new ArgumentNullException(nameof(auditScheduleDetails));
            // Check if the entity already exists
            var existingAuditDetails = await _dbContext.AuditScheduleDetails
                .FirstOrDefaultAsync(d => d.Id == auditScheduleDetails.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingAuditDetails != null)
            {
                // Update existing entity
                _dbContext.Entry(existingAuditDetails).CurrentValues.SetValues(auditScheduleDetails);
            }
            else
            {
                // Add new entity
                await _dbContext.AuditScheduleDetails.AddAsync(auditScheduleDetails, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return auditScheduleDetails;
        }
    }




}
