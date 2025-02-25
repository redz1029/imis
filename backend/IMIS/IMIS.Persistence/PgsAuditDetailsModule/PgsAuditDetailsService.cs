using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;


namespace IMIS.Persistence.PgsModule
{   
    public class PgsAuditDetailsService(IPgsAuditDetailsRepository repository, IOfficeRepository officeRepository, IPgsPeriodRepository pgsPeriodRepository, IKraRepository kraRepository) : IPgsAuditDetailsService
    {
        private readonly IPgsAuditDetailsRepository _repository = repository;
        private readonly IOfficeRepository _officeRepository = officeRepository;
        private readonly IPgsPeriodRepository _pgsPeriodRepository = pgsPeriodRepository;
        private readonly IKraRepository _kraRepository = kraRepository;
        public async Task<PgsAuditDetailsDto> SaveOrUpdateAsync(PgsAuditDetailsDto PGSDto, CancellationToken cancellationToken)
        {
            if (PGSDto == null) throw new ArgumentNullException(nameof(PGSDto));

            // Convert DTO to entity
            var pgsEntity = PGSDto.ToEntity();

            pgsEntity.Office = await _officeRepository.GetByIdAsync(pgsEntity.Office.Id, cancellationToken).ConfigureAwait(false);
            pgsEntity.PgsPeriod = await _pgsPeriodRepository.GetByIdAsync(pgsEntity.PgsPeriod.Id, cancellationToken).ConfigureAwait(false);
            
            if(pgsEntity.PgsDeliverables != null)
            {
                foreach (var deliverable in pgsEntity.PgsDeliverables)
                {
                    deliverable.Kra = await _kraRepository.GetByIdAsync(deliverable!.Kra!.Id, cancellationToken).ConfigureAwait(false);
                }
            }
            // Handle Save or Update
            var createdPgs = await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);            
            return new PgsAuditDetailsDto
            {
                Id = createdPgs.Id,
                Status = createdPgs.Status,
                Remarks = createdPgs.Remarks,
                PgsPeriod =  new PgsPeriodDto
                {
                    Id = createdPgs.PgsPeriod.Id,
                    StartDate = createdPgs.PgsPeriod.StartDate,
                    EndDate = createdPgs.PgsPeriod.EndDate
                },
                Office = new OfficeDto
                {
                    Id = createdPgs.Office.Id,
                    Name = createdPgs.Office.Name,
                    IsActive = createdPgs.Office.IsActive
                },
                PgsDeliverables = createdPgs.PgsDeliverables?
                .Select(deliverable => new PGSDeliverableDto
                {
                    Id = deliverable.Id,
                    IsDirect = deliverable.IsDirect,
                    DeliverableName = deliverable.DeliverableName,
                    ByWhen = deliverable.ByWhen,
                    PercentDeliverables = deliverable.PercentDeliverables,
                    Status = deliverable.Status,
                    RowVersion = deliverable.RowVersion,
                    Kra = deliverable.Kra != null ? new KraDto
                    {
                        Id = deliverable.Kra.Id,
                        Name = deliverable.Kra.Name,  
                        Remarks = deliverable.Kra.Remarks 
                    } : null,
                    Remarks = deliverable.Remarks
                }).ToList()
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
