using Base.Abstractions;
using IMIS.Application.PolicyAndProcedureDCRRFModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PolicyAndProcedureDCRRFModule
{
    public class PolicyAndProcedureDCRRFRepository : BaseRepository<PolicyAndProcedureDCRRF, long, ImisDbContext, User>, IPolicyAndProcedureDCRRFRepository
    {
        public PolicyAndProcedureDCRRFRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<PolicyAndProcedureDCRRF?> GetByIdWithListAsync(long policyAndProcedureId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PolicyAndProcedureDCRRF>()
            .AsNoTracking()
            .Include(x => x.PolicyAndProcedure)         
            .FirstOrDefaultAsync(x => x.PolicyAndProcedureId == policyAndProcedureId && !x.IsDeleted, cancellationToken)
            .ConfigureAwait(false);
        }
    }
}
    