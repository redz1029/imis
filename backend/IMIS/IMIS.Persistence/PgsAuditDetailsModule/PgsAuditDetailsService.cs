using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;

namespace IMIS.Persistence.PgsModule
{   
    public class PgsAuditDetailsService(IPgsAuditDetailsRepository repository) : IPgsAuditDetailsService
    {
        private readonly IPgsAuditDetailsRepository _repository = repository;
        public async Task<PgsAuditDetailsDto> SaveOrUpdateAsync(PgsAuditDetailsDto PGSDto, CancellationToken cancellationToken)
        {
            if (PGSDto == null) throw new ArgumentNullException(nameof(PGSDto));
            // Convert DTO to entity
            var pgsEntity = PGSDto.ToEntity();
            // Handle Save or Update
            var createdPgs = await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
            // Return updated DTO with nested values (handle potential nulls)
            return new PgsAuditDetailsDto
            {
                Id = createdPgs.Id,
                Status = createdPgs.Status,
                Remarks = createdPgs.Remarks,
                PgsPeriod = createdPgs.PgsPeriod != null ? new PgsPeriodDto
                {
                    Id = createdPgs.PgsPeriod.Id,
                    StartDate = createdPgs.PgsPeriod.StartDate,
                    EndDate = createdPgs.PgsPeriod.EndDate
                } : null,
                Office = createdPgs.Office != null ? new OfficeDto
                {
                    Id = createdPgs.Office.Id,
                    Name = createdPgs.Office.Name,
                    IsActive = createdPgs.Office.IsActive
                } : null
            };
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsAuditDetailsDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
