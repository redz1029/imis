using Base.Abstractions;
using IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PolicyAndProcedureOfficeDocumentDistributionModule
{
    public class PolicyAndProcedureOfficeDocumentDistributionRepository : BaseRepository<PolicyAndProcedureOfficeDocumentDistribution, long, ImisDbContext, User>, IPolicyAndProcedureOfficeDocumentDistributionRepository
    {
        public PolicyAndProcedureOfficeDocumentDistributionRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<PolicyAndProcedureOfficeDocumentDistribution?> GetByIdWithListAsync(long policyAndProcedureId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PolicyAndProcedureOfficeDocumentDistribution>()
            .AsNoTracking()
            .Include(x => x.PolicyAndProcedure)
            .Include(x => x.OfficeDocumentDistributionList.Where(l => !l.IsDeleted))
            .FirstOrDefaultAsync(x => x.PolicyAndProcedureId == policyAndProcedureId && !x.IsDeleted, cancellationToken)
            .ConfigureAwait(false);
        }
    }

}
