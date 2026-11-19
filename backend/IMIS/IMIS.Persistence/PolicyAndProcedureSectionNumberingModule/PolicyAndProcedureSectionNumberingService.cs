using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PolicyAndProcedureSectionNumberingModule;
using IMIS.Domain;

namespace IMIS.Persistence.PolicyAndProcedureSectionNumberingModule
{
    public class PolicyAndProcedureSectionNumberingService : IPolicyAndProcedureSectionNumberingService
    {

        private readonly IPolicyAndProcedureSectionNumberingRepository _repository;

        public PolicyAndProcedureSectionNumberingService(IPolicyAndProcedureSectionNumberingRepository repository)
        {
            _repository = repository;
        }
        public async Task<PolicyAndProcedureSectionNumberingDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var ODto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return ODto != null ? new PolicyAndProcedureSectionNumberingDto(ODto) : null;
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
        public async Task<List<PolicyAndProcedureSectionNumberingDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var ODto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (ODto == null)
                return null;

            return ODto.Select(d => new PolicyAndProcedureSectionNumberingDto(d)).ToList();
        }
        public async Task<DtoPageList<PolicyAndProcedureSectionNumberingDto, PolicyAndProcedureSectionNumbering, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var ODto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (ODto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<PolicyAndProcedureSectionNumberingDto, PolicyAndProcedureSectionNumbering, int>.Create(ODto.Items, page, pageSize, ODto.TotalCount);
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as PolicyAndProcedureSectionNumberingDto;
            var policyAndProcedureSectionNumberingDto = ODto!.ToEntity();

            if (policyAndProcedureSectionNumberingDto.Id == 0)
                _repository.Add(policyAndProcedureSectionNumberingDto);
            else
                await _repository.UpdateAsync(policyAndProcedureSectionNumberingDto, policyAndProcedureSectionNumberingDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(policyAndProcedureSectionNumberingDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
