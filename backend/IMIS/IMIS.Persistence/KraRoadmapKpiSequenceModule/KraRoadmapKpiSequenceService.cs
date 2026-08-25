using Base.Pagination;
using Base.Primitives;
using IMIS.Application.KraRoadmapKpiSequenceModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraRoadmapKpiSequenceModule
{
    public class KraRoadmapKpiSequenceService : IKraRoadmapKpiSequenceService
    {
        private readonly IKraRoadmapKpiSequenceRepository _repository;

        public KraRoadmapKpiSequenceService(IKraRoadmapKpiSequenceRepository repository)
        {
            _repository = repository;
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var kraRoadmapKpiSequenceDto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (kraRoadmapKpiSequenceDto == null)
                return false;

            kraRoadmapKpiSequenceDto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<DtoPageList<KraRoadmapKpiSequenceDto, KraRoadmapKpiSequence, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var kraRoadmapKpiSequenceDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (kraRoadmapKpiSequenceDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<KraRoadmapKpiSequenceDto, KraRoadmapKpiSequence, int>.Create(kraRoadmapKpiSequenceDto.Items, page, pageSize, kraRoadmapKpiSequenceDto.TotalCount);
        }
        public async Task<List<KraRoadmapKpiSequenceDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var kraRoadmapKpiSequenceDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (kraRoadmapKpiSequenceDto == null)
                return null;

            return kraRoadmapKpiSequenceDto.Select(d => new KraRoadmapKpiSequenceDto(d)).ToList();
        }
        public async Task<KraRoadmapKpiSequenceDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var kraRoadmapKpiSequenceDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return kraRoadmapKpiSequenceDto != null ? new KraRoadmapKpiSequenceDto(kraRoadmapKpiSequenceDto) : null;
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
       where TEntity : Entity<TId>
        {
            var ODto = dto as KraRoadmapKpiSequenceDto;
            var kraRoadmapKpiSequenceDto = ODto!.ToEntity();

            if (kraRoadmapKpiSequenceDto.Id == 0)
                _repository.Add(kraRoadmapKpiSequenceDto);
            else
                await _repository.UpdateAsync(kraRoadmapKpiSequenceDto, kraRoadmapKpiSequenceDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(kraRoadmapKpiSequenceDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
