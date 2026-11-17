using Base.Primitives;
using IMIS.Application.PolicyAndProcedureDCRRFModule;

namespace IMIS.Persistence.PolicyAndProcedureDCRRFModule
{
    public class PolicyAndProcedureDCRRFService : IPolicyAndProcedureDCRRFService
    {
        private readonly IPolicyAndProcedureDCRRFRepository _repository;
     
        public PolicyAndProcedureDCRRFService(IPolicyAndProcedureDCRRFRepository repository)
        {
            _repository = repository;         
        }
        public async Task<PolicyAndProcedureDCRRFDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithListAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new PolicyAndProcedureDCRRFDto(entity) : null;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as PolicyAndProcedureDCRRFDto;
            var policyAndProcedureDCRRFDto = ODto!.ToEntity();
          
            if (policyAndProcedureDCRRFDto.Id == 0)
                _repository.Add(policyAndProcedureDCRRFDto);
            else
                await _repository.UpdateAsync(policyAndProcedureDCRRFDto, policyAndProcedureDCRRFDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(policyAndProcedureDCRRFDto, cancellationToken).ConfigureAwait(false);
        }       
    }
}
