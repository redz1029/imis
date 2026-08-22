using Base.Pagination;
using Base.Primitives;
using IMIS.Application.SWOTAnalysisStrengthWeaknessModule;
using IMIS.Domain;

namespace IMIS.Persistence.SWOTAnalysisStrengthWeaknessModule
{
    public class SWOTAnalysisStrengthWeaknessService : ISWOTAnalysisStrengthWeaknessService
    {
        private readonly ISWOTAnalysisStrengthWeaknessRepository _repository;

        public SWOTAnalysisStrengthWeaknessService(ISWOTAnalysisStrengthWeaknessRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var sWOTAnalysisDto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (sWOTAnalysisDto == null)
                return false;

            sWOTAnalysisDto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<DtoPageList<SWOTAnalysisStrengthWeaknessDto, SWOTAnalysisStrengthWeakness, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var sWOTAnalysisDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (sWOTAnalysisDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<SWOTAnalysisStrengthWeaknessDto, SWOTAnalysisStrengthWeakness, int>.Create(sWOTAnalysisDto.Items, page, pageSize, sWOTAnalysisDto.TotalCount);
        }
        public async Task<SWOTAnalysisStrengthWeaknessDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var sWOTAnalysisDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return sWOTAnalysisDto != null ? new SWOTAnalysisStrengthWeaknessDto(sWOTAnalysisDto) : null;
        }
        public async Task<List<SWOTAnalysisStrengthWeaknessDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var sWOTAnalysisDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (sWOTAnalysisDto == null)
                return null;

            return sWOTAnalysisDto.Select(d => new SWOTAnalysisStrengthWeaknessDto(d)).ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as SWOTAnalysisStrengthWeaknessDto;
            var enittyDto = ODto!.ToEntity();

            if (enittyDto.Id == 0)
                _repository.Add(enittyDto);
            else
                await _repository.UpdateAsync(enittyDto, enittyDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(enittyDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
