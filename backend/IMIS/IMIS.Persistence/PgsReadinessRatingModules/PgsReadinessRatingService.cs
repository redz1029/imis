using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Application.UserOfficeModule;
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
        public async Task<List<PgsReadinessRatingDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var PgsReadiness = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return PgsReadiness?.Select(o => ConvertToDTO(o)).ToList();
        }
        public async Task<PgsReadinessRatingDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var PgsReadiness = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return PgsReadiness != null ? ConvertToDTO(PgsReadiness) : null;
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsReadinessRatingDto PgsReadinessDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            var entity = PgsReadinessDto.ToEntity();
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }
    }
}
