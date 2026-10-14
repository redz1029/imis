using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PolicyAndProcedureModule;
using IMIS.Domain;

namespace IMIS.Persistence.PolicyAndProcedureModule
{
    public class PolicyAndProcedureService : IPolicyAndProcedureService
    {
        private readonly IPolicyAndProcedureRepository _repository;
        public PolicyAndProcedureService(IPolicyAndProcedureRepository repository)
        {
            _repository = repository;
        }
        public async Task<DtoPageList<PolicyAndProcedureDto, PolicyAndProcedure, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var ODto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (ODto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<PolicyAndProcedureDto, PolicyAndProcedure, long>.Create(ODto.Items, page, pageSize, ODto.TotalCount);
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var ODto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (ODto == null)
                return false;

            ODto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<PolicyAndProcedureDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var ODto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return ODto != null ? new PolicyAndProcedureDto(ODto) : null;
        }
     
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is PolicyAndProcedureDto PolicyAndProcedureDto)
            {
                var protocol = PolicyAndProcedureDto.ToEntity();

                if (protocol.Id == 0)
                    _repository.Add(protocol);
                else
                    await _repository.UpdateAsync(protocol, protocol.Id, cancellationToken)
                        .ConfigureAwait(false);

                await _repository.SaveOrUpdateAsync(protocol, cancellationToken)
                    .ConfigureAwait(false);

            }
        }
    }
}
