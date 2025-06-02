using Base.Pagination;
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
        public async Task<DtoPageList<PgsPeriodDto, PgsPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsPeriod = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if(pgsPeriod.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<PgsPeriodDto, PgsPeriod, int>.Create(pgsPeriod.Items, page, pageSize, pgsPeriod.TotalCount);
        }
        private PgsPeriodDto ConvPgsPeriodToDTO(PgsPeriod period)
        {
            if (period == null) return null;

            return new PgsPeriodDto
            {
                Id = period.Id,
                StartDate = period.StartDate,
                EndDate = period.EndDate,
                Remarks = period.Remarks,
            };
        }
        public async Task<PgsPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var period = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return period != null ? ConvPgsPeriodToDTO(period) : null;
        }
        public async Task<List<PgsPeriodDto>?> GetAllAsync(CancellationToken cancellationToken) 
        {
            var periods = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return periods?.Select(o => ConvPgsPeriodToDTO(o)).ToList();
        }
        public async Task<PgsPeriodDto> SaveOrUpdateAsync(PgsPeriodDto pgsPeriodDto, CancellationToken cancellationToken)
        {
            if (pgsPeriodDto == null) throw new ArgumentNullException(nameof(PgsPeriodDto));

            PgsPeriod pgsPeriodEntity;
            // Check if the period exists, and update it, otherwise create a new one
            if (pgsPeriodDto.Id > 0)
            {
                // Update logic
                var existingPeriod = await _repository.GetByIdAsync(pgsPeriodDto.Id, cancellationToken).ConfigureAwait(false);
                if (existingPeriod != null)
                {                   
                    existingPeriod.StartDate = pgsPeriodDto.StartDate;
                    existingPeriod.EndDate = pgsPeriodDto.EndDate;

                    // Update the existing entity
                    pgsPeriodEntity = existingPeriod;
                }
                else
                {
                    // If the period doesn't exist, create a new one
                    pgsPeriodEntity = pgsPeriodDto.ToEntity();
                }
            }
            else
            {
                // Create a new record if ID is 0 or not specified
                pgsPeriodEntity = pgsPeriodDto.ToEntity();
            }
            var savedPgsPeriod = await _repository.SaveOrUpdateAsync(pgsPeriodEntity, cancellationToken).ConfigureAwait(false);
            return new PgsPeriodDto
            {
                Id = savedPgsPeriod.Id,
                StartDate = savedPgsPeriod.StartDate,
                EndDate = savedPgsPeriod.EndDate,
                Remarks = savedPgsPeriod.Remarks,
            };
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> pgsPeriodDto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (pgsPeriodDto is not PgsPeriodDto periodDto) throw new ArgumentException("Invalid Pgs Period type", nameof(PgsPeriodDto));
            var pgsPeriodEntity = periodDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsPeriodEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
