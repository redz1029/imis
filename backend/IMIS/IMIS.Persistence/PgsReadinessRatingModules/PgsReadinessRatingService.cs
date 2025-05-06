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
        private PgsReadinessRatingDto ConvertToDTO(PgsReadinessRating pgsReadinessRating)
        {
            if (pgsReadinessRating == null) return null;

            return new PgsReadinessRatingDto
            {
                Id = pgsReadinessRating.Id,
                CompetenceToDeliver = pgsReadinessRating.CompetenceToDeliver,
                ResourceAvailability = pgsReadinessRating.ResourceAvailability,
                ConfidenceToDeliver = pgsReadinessRating.ConfidenceToDeliver,
                TotalScore = pgsReadinessRating.TotalScore
            };
        }      
        public async Task<PgsReadinessRatingDto> SaveOrUpdateAsync(PgsReadinessRatingDto pgsReadinessRatingDto, CancellationToken cancellationToken)
        {
            if (pgsReadinessRatingDto == null) throw new ArgumentNullException(nameof(pgsReadinessRatingDto));

            var pgsReadinessRating = new PgsReadinessRating
            {
                Id = pgsReadinessRatingDto.Id,
                CompetenceToDeliver = pgsReadinessRatingDto.CompetenceToDeliver,
                ResourceAvailability = pgsReadinessRatingDto.ResourceAvailability,
                ConfidenceToDeliver = pgsReadinessRatingDto.ConfidenceToDeliver
            };
            var updatedPgsReadinessRating = await _repository.SaveOrUpdateAsync(pgsReadinessRating, cancellationToken);
            return ConvertToDTO(updatedPgsReadinessRating);
        }
        public async Task<List<PgsReadinessRatingDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pgsReadiness = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return pgsReadiness?.Select(o => ConvertToDTO(o)).ToList();
        }
        public async Task<PgsReadinessRatingDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgsReadiness = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pgsReadiness != null ? ConvertToDTO(pgsReadiness) : null;
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsReadinessRatingDto pgsReadinessDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            var entity = pgsReadinessDto.ToEntity();
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }
        public async Task<DtoPageList<PgsReadinessRatingDto, PgsReadinessRating, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsReadiness = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (pgsReadiness.TotalCount == 0)
                return null;
            return DtoPageList<PgsReadinessRatingDto, PgsReadinessRating, long>.Create(pgsReadiness.Items, page, pageSize, pgsReadiness.TotalCount);
        }
    }
}
