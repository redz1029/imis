using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;

namespace IMIS.Persistence.PGSReadinessRatingCancerCareModule
{
    public class PgsReadinessRatingService : IPgsReadinessRatingService
    {
        private readonly IPgsReadinessRatingRepository _repository;
        public PgsReadinessRatingService(IPgsReadinessRatingRepository repository)
        {
            _repository = repository;
        }                            
        public async Task<List<PgsReadinessRatingDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pgsReadiness = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (pgsReadiness == null)
                return null;

            return pgsReadiness.Select(d => new PgsReadinessRatingDto(d)).ToList();
        }
        public async Task<PgsReadinessRatingDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgsReadiness = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pgsReadiness != null ? new PgsReadinessRatingDto(pgsReadiness) : null;
        }      
        public async Task<DtoPageList<PgsReadinessRatingDto, PgsReadinessRating, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsReadiness = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (pgsReadiness.TotalCount == 0)
                return null;
            return DtoPageList<PgsReadinessRatingDto, PgsReadinessRating, long>.Create(pgsReadiness.Items, page, pageSize, pgsReadiness.TotalCount);
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {           
            var ODto = dto as PgsReadinessRatingDto;
            var pgsReadinessRatingDto = ODto!.ToEntity();

            if (pgsReadinessRatingDto.Id == 0)
                _repository.Add(pgsReadinessRatingDto);
            else
                await _repository.UpdateAsync(pgsReadinessRatingDto, pgsReadinessRatingDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(pgsReadinessRatingDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
