using Base.Primitives;
using IMIS.Application.SWOTAnalysisModule;

namespace IMIS.Persistence.SWOTAnalysisModule
{
    public class SWOTAnalysisService : ISWOTAnalysisService
    {
        private readonly ISWOTAnalysisRepository _repository;
        public SWOTAnalysisService(ISWOTAnalysisRepository repository)
        {
            _repository = repository;
        }
        public async Task<SWOTAnalysisDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var swotAnalysis = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return swotAnalysis != null ? new SWOTAnalysisDto(swotAnalysis) : null;
        }     
        public async Task<List<SWOTAnalysisDto>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByUserIdAsync(userId, cancellationToken).ConfigureAwait(false);

            if (entities == null)
                return null;

            return entities.Select(e => new SWOTAnalysisDto(e)).ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as SWOTAnalysisDto;
            var swotAnalysisDto = ODto!.ToEntity();

            if (swotAnalysisDto.Id == 0)
                _repository.Add(swotAnalysisDto);
            else
                await _repository.UpdateAsync(swotAnalysisDto, swotAnalysisDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(swotAnalysisDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
