using Base.Abstractions;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using IMIS.Persistence;
using Microsoft.EntityFrameworkCore;

public class PgsAuditDetailsRepository : BaseRepository<PgsAuditDetails, long, ImisDbContext>, IPgsAuditDetailsRepository
{
    public PgsAuditDetailsRepository(ImisDbContext dbContext) : base(dbContext)
    {

    }
    public new async Task<PgsAuditDetails> SaveOrUpdateAsync(PgsAuditDetails pgs, CancellationToken cancellationToken)
    {
        if (pgs == null) throw new ArgumentNullException(nameof(pgs));
       
        var existingPgs = await _dbContext.PgsAuditDetails
            .FirstOrDefaultAsync(d => d.Id == pgs.Id, cancellationToken)
            .ConfigureAwait(false);

        if (existingPgs != null)
        {
            // Update the existing record's values
            _dbContext.Entry(existingPgs).CurrentValues.SetValues(pgs);
        }
        else
        {
            // Add a new PgsAuditDetails if not found
            await _dbContext.PgsAuditDetails.AddAsync(pgs, cancellationToken).ConfigureAwait(false);
        }

        // Save changes to the database
        await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
        return pgs;
    }

    // Returns the total count of PgsAuditDetails
    public Task<int> CountAsync(CancellationToken cancellationToken)
    {
       
        return _dbContext.PgsAuditDetails.CountAsync(cancellationToken);
    }
    public async Task<IEnumerable<PgsAuditDetails>> GetPagedAsync(int skip, int pageSize, CancellationToken cancellationToken)
    {
    
        return await _dbContext.PgsAuditDetails.Skip(skip).Take(pageSize).ToListAsync(cancellationToken).ConfigureAwait(false);
    }
}
