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

        // Converts the entity to DTO
        private PgsReadinessRatingDto ConvertToDTO(PgsReadinessRating entity)
        {
            if (entity == null) return null;

            return new PgsReadinessRatingDto
            {
                Id = entity.Id,
                CompetenceToDeliver = entity.CompetenceToDeliver,
                ResourceAvailability = entity.ResourceAvailability,
                ConfidenceToDeliver = entity.ConfidenceToDeliver,
                TotalScore = entity.TotalScore
            };
        }

        // Save or Update Readiness Rating Cancer Care Data
        public async Task<PgsReadinessRatingDto> SaveOrUpdateAsync(PgsReadinessRatingDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) throw new ArgumentNullException(nameof(dto));

            var entity = new PgsReadinessRating
            {
                Id = dto.Id,
                CompetenceToDeliver = dto.CompetenceToDeliver,
                ResourceAvailability = dto.ResourceAvailability,
                ConfidenceToDeliver = dto.ConfidenceToDeliver
            };

            var updatedEntity = await _repository.SaveOrUpdateAsync(entity, cancellationToken);
            return ConvertToDTO(updatedEntity);
        }

        // Generic Save or Update
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsReadinessRatingDto PgsReadinessDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            var entity = PgsReadinessDto.ToEntity();
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }
    }
}
