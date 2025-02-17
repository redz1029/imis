using Base.Primitives;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Persistence.PgsPeriodModule
{
    public class PgsPeriodService : IPgsPeriodService
    {
        private readonly IPgsPeriodRepository _repository;
        public PgsPeriodService(IPgsPeriodRepository repository)
        {
            _repository = repository;
        }
        // Convert PGS Period entity to PgsPeriodDTO       
        private PgsPeriodDto ConvPgsPeriodToDTO(PgsPeriod period)
        {
            if (period == null) return null;

            return new PgsPeriodDto
            {
                Id = period.Id,
                StartDate = period.StartDate,
                EndDate = period.EndDate
            };
        }
        public async Task<PgsPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var period = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return period != null ? ConvPgsPeriodToDTO(period) : null;
        }
        public async Task<List<PgsPeriodDto>?> GetAllAsync(CancellationToken cancellationToken) // Get all data in the PGS Period
        {
            var periods = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return periods?.Select(o => ConvPgsPeriodToDTO(o)).ToList();
        }
        public async Task<PgsPeriodDto> SaveOrUpdateAsync(PgsPeriodDto PgsPeriodDto, CancellationToken cancellationToken)
        {
            if (PgsPeriodDto == null) throw new ArgumentNullException(nameof(PgsPeriodDto));

            PgsPeriod pgsPeriodEntity;
            // Check if the period exists, and update it, otherwise create a new one
            if (PgsPeriodDto.Id > 0)
            {
                // Update logic
                var existingPeriod = await _repository.GetByIdAsync(PgsPeriodDto.Id, cancellationToken).ConfigureAwait(false);
                if (existingPeriod != null)
                {                   
                    existingPeriod.StartDate = PgsPeriodDto.StartDate;
                    existingPeriod.EndDate = PgsPeriodDto.EndDate;

                    // Update the existing entity
                    pgsPeriodEntity = existingPeriod;
                }
                else
                {
                    // If the period doesn't exist, create a new one
                    pgsPeriodEntity = PgsPeriodDto.ToEntity();
                }
            }
            else
            {
                // Create a new record if ID is 0 or not specified
                pgsPeriodEntity = PgsPeriodDto.ToEntity();
            }
            var savedPeriod = await _repository.SaveOrUpdateAsync(pgsPeriodEntity, cancellationToken).ConfigureAwait(false);
            return new PgsPeriodDto
            {
                Id = savedPeriod.Id,
                StartDate = savedPeriod.StartDate,
                EndDate = savedPeriod.EndDate
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
