using Base.Primitives;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.PGSReadinessRatingCancerCareModule
{
    public class PgsReadinessRatingCancerCareService : IPgsReadinessRatingCancerCareService
    {
        private readonly IPGSReadinessRatingCancerCareRepository _repository;

        public PgsReadinessRatingCancerCareService(IPGSReadinessRatingCancerCareRepository repository)
        {
            _repository = repository;
        }

        // Converts the entity to DTO
        private PGSReadinessRatingCancerCareDto ConvertToDTO(PGSReadinessRatingCancerCare entity)
        {
            if (entity == null) return null;

            return new PGSReadinessRatingCancerCareDto
            {
                Id = entity.Id,
                Score1 = entity.Score1,
                Score2 = entity.Score2,
                Score3 = entity.Score3,
                TotalScore = entity.TotalScore
            };
        }

        // Save or Update Readiness Rating Cancer Care Data
        public async Task<PGSReadinessRatingCancerCareDto> SaveOrUpdateAsync(PGSReadinessRatingCancerCareDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) throw new ArgumentNullException(nameof(dto));

            var entity = new PGSReadinessRatingCancerCare
            {
                Id = dto.Id,
                Score1 = dto.Score1,
                Score2 = dto.Score2,
                Score3 = dto.Score3
            };

            var updatedEntity = await _repository.SaveOrUpdateAsync(entity, cancellationToken);
            return ConvertToDTO(updatedEntity);
        }

        // Generic Save or Update
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PGSReadinessRatingCancerCareDto PgsReadinessDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            var entity = PgsReadinessDto.ToEntity();
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }
    }
}
