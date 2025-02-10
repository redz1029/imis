using Base.Primitives;
using IMIS.Application.PgsPeriodModule;

namespace IMIS.Persistence.PgsPeriodModule
{

    public class PgsPeriodService(IPgsPeriodRepository repository) : IPgsPeriodService
    {

        private readonly IPgsPeriodRepository _repository = repository;

        public async Task<PgsPeriodDto> SaveOrUpdateAsync(PgsPeriodDto PgsPeriodDto, CancellationToken cancellationToken)
        {

            if (PgsPeriodDto == null) throw new ArgumentNullException(nameof(PgsPeriodDto));

            var PgsPeriodEntity = PgsPeriodDto.ToEntity();
            var createdPgsPeriod = await _repository.SaveOrUpdateAsync(PgsPeriodEntity, cancellationToken).ConfigureAwait(false);

            return new PgsPeriodDto
            {
                Id = createdPgsPeriod.Id,
                StartDate= createdPgsPeriod.StartDate,
                EndDate = createdPgsPeriod.EndDate
            };
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> PgsPeriodDto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (PgsPeriodDto is not PgsPeriodDto PeriodDto) throw new ArgumentException("Invalid DTO type", nameof(PgsPeriodDto));

            var PgsPeriodEntity = PeriodDto.ToEntity();
            await _repository.SaveOrUpdateAsync(PgsPeriodEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
