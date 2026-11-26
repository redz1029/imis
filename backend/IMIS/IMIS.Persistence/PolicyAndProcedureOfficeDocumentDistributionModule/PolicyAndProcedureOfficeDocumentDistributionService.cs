using Base.Primitives;
using IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionModule;

namespace IMIS.Persistence.PolicyAndProcedureOfficeDocumentDistributionModule
{
    public class PolicyAndProcedureOfficeDocumentDistributionService : IPolicyAndProcedureOfficeDocumentDistributionService
    {

        public Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            throw new NotImplementedException();
        }
    }
}
