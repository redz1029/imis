using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;
using static IMIS.Application.PgsModule.PgsAuditDetailsDto;

namespace IMIS.Persistence.PgsModule
{
    public class PgsAuditDetailsService : IPgsAuditDetailsService
    {
        private readonly IPgsAuditDetailsRepository _repository;
        private readonly IOfficeRepository _officeRepository;
        private readonly IPgsPeriodRepository _pgsPeriodRepository;
        private readonly IKeyResultAreaRepository _kraRepository;

        public PgsAuditDetailsService(IPgsAuditDetailsRepository repository, IOfficeRepository officeRepository, IPgsPeriodRepository pgsPeriodRepository, IKeyResultAreaRepository kraRepository)
        {
            _repository = repository;
            _officeRepository = officeRepository;
            _pgsPeriodRepository = pgsPeriodRepository;
            _kraRepository = kraRepository;
        }     
        private PgsAuditDetailsDto ConvPgsAuditDetailsToDTO(PgsAuditDetails auditDetails)
        {
            if (auditDetails == null) return null;

            return new PgsAuditDetailsDto
            {
                Id = auditDetails.Id,
                Remarks = auditDetails.Remarks,

                PgsPeriod = auditDetails.PgsPeriod != null ? new PgsPeriodDto
                {
                    Id = auditDetails.PgsPeriod.Id,
                    StartDate = auditDetails.PgsPeriod.StartDate,
                    EndDate = auditDetails.PgsPeriod.EndDate
                } : null,  

                Office = auditDetails.Office != null ? new OfficeDto
                {
                    Id = auditDetails.Office.Id,
                    Name = auditDetails.Office.Name,
                    IsActive = auditDetails.Office.IsActive
                } : null, 

                PgsReadinessRating = auditDetails.PgsReadinessRating != null ? new PgsReadinessRatingDto
                {
                    Id = auditDetails.PgsReadinessRating.Id,
                    CompetenceToDeliver = auditDetails.PgsReadinessRating.CompetenceToDeliver,
                    ResourceAvailability = auditDetails.PgsReadinessRating.ResourceAvailability,
                    ConfidenceToDeliver = auditDetails.PgsReadinessRating.ConfidenceToDeliver,
                } : null,  

                PgsDeliverables = auditDetails.PgsDeliverables?.Select(deliverable => new PGSDeliverableDto
                {
                    Id = deliverable.Id,
                    IsDirect = deliverable.IsDirect,
                    DeliverableName = deliverable.DeliverableName,
                    ByWhen = deliverable.ByWhen,
                    PercentDeliverables = deliverable.PercentDeliverables,
                    Status = deliverable.Status,
                    RowVersion = deliverable.RowVersion,
                    Kra = deliverable.Kra != null ? new KeyResultAreaDto
                    {
                        Id = deliverable.Kra.Id,
                        Name = deliverable.Kra.Name,
                        Remarks = deliverable.Kra.Remarks
                    } : null, 
                    Remarks = deliverable.Remarks
                }).ToList() ?? new List<PGSDeliverableDto>()  
            };
        }
        public async Task<PgsAuditDetailsDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgsAuditDetails = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pgsAuditDetails != null ? ConvPgsAuditDetailsToDTO(pgsAuditDetails) : null;
        }
        public async Task<List<PgsAuditDetailsDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pgsAuditDetails = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return pgsAuditDetails?.Select(o => ConvPgsAuditDetailsToDTO(o)).ToList();
        }
        public async Task<DtoPageList<PgsAuditDetailsDto, PgsAuditDetails, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsAuditDetails = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (pgsAuditDetails.TotalCount == 0)
                return null;
            return DtoPageList<PgsAuditDetailsDto, PgsAuditDetails, long>.Create(pgsAuditDetails.Items, page, pageSize, pgsAuditDetails.TotalCount);
        }
        // Save or Update PgsAuditDetails
        public async Task<PgsAuditDetailsDto> SaveOrUpdateAsync(PgsAuditDetailsDto pgsAuditDetailsDto, CancellationToken cancellationToken)
        {
            if (pgsAuditDetailsDto == null) throw new ArgumentNullException(nameof(pgsAuditDetailsDto));

            // Convert DTO to entity
            var pgsEntity = pgsAuditDetailsDto.ToEntity();
            pgsEntity.Office = await _officeRepository.GetByIdAsync(pgsEntity.Office.Id, cancellationToken).ConfigureAwait(false);
            pgsEntity.PgsPeriod = await _pgsPeriodRepository.GetByIdAsync(pgsEntity.PgsPeriod.Id, cancellationToken).ConfigureAwait(false);

            if (pgsEntity.PgsDeliverables != null)
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
                Remarks = createdPgs.Remarks,
                PgsPeriod = new PgsPeriodDto
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
                PgsReadinessRating = new PgsReadinessRatingDto
                {
                    Id = createdPgs.PgsReadinessRating!.Id,
                    CompetenceToDeliver = createdPgs.PgsReadinessRating.CompetenceToDeliver,
                    ResourceAvailability = createdPgs.PgsReadinessRating.ResourceAvailability,
                    ConfidenceToDeliver = createdPgs.PgsReadinessRating.ConfidenceToDeliver,
                },
                PgsDeliverables = createdPgs.PgsDeliverables?.Select(deliverable => new PGSDeliverableDto
                {
                    Id = deliverable.Id,
                    IsDirect = deliverable.IsDirect,
                    DeliverableName = deliverable.DeliverableName,
                    ByWhen = deliverable.ByWhen,
                    PercentDeliverables = deliverable.PercentDeliverables,
                    Status = deliverable.Status,
                    RowVersion = deliverable.RowVersion,
                    Kra = deliverable.Kra != null ? new KeyResultAreaDto
                    {
                        Id = deliverable.Kra.Id,
                        Name = deliverable.Kra.Name,
                        Remarks = deliverable.Kra.Remarks
                    } : null,
                    Remarks = deliverable.Remarks
                }).ToList()
            };
        }
        // Save or Update Generic Method
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsAuditDetailsDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
