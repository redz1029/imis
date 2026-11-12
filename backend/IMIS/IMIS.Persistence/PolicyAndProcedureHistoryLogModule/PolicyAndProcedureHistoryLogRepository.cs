using Base.Abstractions;
using IMIS.Application.PolicyAndProcedureHistoryLogModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PolicyAndProcedureHistoryLogModule
{
    public class PolicyAndProcedureHistoryLogRepository : BaseRepository<PolicyAndProcedureHistoryLog, long, ImisDbContext, User>, IPolicyAndProcedureHistoryLogRepository
    {

        public PolicyAndProcedureHistoryLogRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<PolicyAndProcedureHistoryLog?> GetByIdWithListAsync(long policyAndProcedureId, CancellationToken cancellationToken)
        {           
            return await ReadOnlyDbContext.Set<PolicyAndProcedureHistoryLog>()
            .AsNoTracking()
            .Include(x => x.PolicyAndProcedure)
            .Include(x => x.HistoryLogLists.Where(l => !l.IsDeleted))
            .FirstOrDefaultAsync(x => x.PolicyAndProcedureId == policyAndProcedureId && !x.IsDeleted, cancellationToken)
            .ConfigureAwait(false);
        }
    }
}