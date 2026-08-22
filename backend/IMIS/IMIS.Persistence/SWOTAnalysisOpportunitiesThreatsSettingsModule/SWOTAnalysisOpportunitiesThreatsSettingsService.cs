using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule;
using IMIS.Domain;

namespace IMIS.Persistence.SWOTAnalysisOpportunitiesThreatsModule
{
    public class SWOTAnalysisOpportunitiesThreatsSettingsService : ISWOTAnalysisOpportunitiesThreatsSettingsService
    {
        private readonly ISWOTAnalysisOpportunitiesThreatsSettingsRepository _repository;

        public SWOTAnalysisOpportunitiesThreatsSettingsService(ISWOTAnalysisOpportunitiesThreatsSettingsRepository repository)
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
        public async Task<DtoPageList<SWOTAnalysisOpportunitiesThreatsSettingsDto, SWOTAnalysisOpportunitiesThreatsSettings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var sWOTAnalysisDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (sWOTAnalysisDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<SWOTAnalysisOpportunitiesThreatsSettingsDto, SWOTAnalysisOpportunitiesThreatsSettings, int>.Create(sWOTAnalysisDto.Items, page, pageSize, sWOTAnalysisDto.TotalCount);
        }
        public async Task<SWOTAnalysisOpportunitiesThreatsSettingsDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var sWOTAnalysisDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return sWOTAnalysisDto != null ? new SWOTAnalysisOpportunitiesThreatsSettingsDto(sWOTAnalysisDto) : null;
        }
        public async Task<List<SWOTAnalysisOpportunitiesThreatsSettingsDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var sWOTAnalysisDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (sWOTAnalysisDto == null)
                return null;

            return sWOTAnalysisDto.Select(d => new SWOTAnalysisOpportunitiesThreatsSettingsDto(d)).ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as SWOTAnalysisOpportunitiesThreatsSettingsDto;
            var enittyDto = ODto!.ToEntity();

            if (enittyDto.Id == 0)
                _repository.Add(enittyDto);
            else
                await _repository.UpdateAsync(enittyDto, enittyDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(enittyDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
