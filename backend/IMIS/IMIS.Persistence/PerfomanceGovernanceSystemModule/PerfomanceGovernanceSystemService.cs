using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;

namespace IMIS.Persistence.PgsModule
{
    public class PerfomanceGovernanceSystemService : IPerfomanceGovernanceSystemService
    {
        private readonly IPerfomanceGovernanceSystemRepository _repository;
        private readonly IOfficeRepository _officeRepository;
        private readonly IPgsPeriodRepository _pgsPeriodRepository;
        private readonly IKeyResultAreaRepository _kraRepository;

        public PerfomanceGovernanceSystemService(IPerfomanceGovernanceSystemRepository repository, IOfficeRepository officeRepository, IPgsPeriodRepository pgsPeriodRepository, IKeyResultAreaRepository kraRepository)
        {
            _repository = repository;
            _officeRepository = officeRepository;
            _pgsPeriodRepository = pgsPeriodRepository;
            _kraRepository = kraRepository;
        }     
        private PerfomanceGovernanceSystemDto ConvPerfomanceGovernanceSystemToDTO(PerfomanceGovernanceSystem perfomanceGovernanceSystem)
        {
            if (perfomanceGovernanceSystem == null) return null;

            return new PerfomanceGovernanceSystemDto
            {
                Id = perfomanceGovernanceSystem.Id,
                Remarks = perfomanceGovernanceSystem.Remarks,                                
                PgsPeriod = perfomanceGovernanceSystem.PgsPeriod != null ? new PgsPeriodDto
                {                 
                    Id = perfomanceGovernanceSystem.PgsPeriod.Id,
                    StartDate = perfomanceGovernanceSystem.PgsPeriod.StartDate,
                    EndDate = perfomanceGovernanceSystem.PgsPeriod.EndDate
                } : null,  

                Office = perfomanceGovernanceSystem.Office != null ? new OfficeDto
                {
                    Id = perfomanceGovernanceSystem.Office.Id,
                    Name = perfomanceGovernanceSystem.Office.Name,
                    IsActive = perfomanceGovernanceSystem.Office.IsActive
                } : null, 

                PgsReadinessRating = perfomanceGovernanceSystem.PgsReadinessRating != null ? new PgsReadinessRatingDto
                {
                    Id = perfomanceGovernanceSystem.PgsReadinessRating.Id,
                    CompetenceToDeliver = perfomanceGovernanceSystem.PgsReadinessRating.CompetenceToDeliver,
                    ResourceAvailability = perfomanceGovernanceSystem.PgsReadinessRating.ResourceAvailability,
                    ConfidenceToDeliver = perfomanceGovernanceSystem.PgsReadinessRating.ConfidenceToDeliver,
                } : null,  

                PgsDeliverables = perfomanceGovernanceSystem.PgsDeliverables?.Select(deliverable => new PGSDeliverableDto
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
        public async Task<PerfomanceGovernanceSystemDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var perfomanceGovernanceSystemDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return perfomanceGovernanceSystemDto != null ? ConvPerfomanceGovernanceSystemToDTO(perfomanceGovernanceSystemDto) : null;
        }
        public async Task<List<PerfomanceGovernanceSystemDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var perfomanceGovernanceSystemDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return perfomanceGovernanceSystemDto?.Select(o => ConvPerfomanceGovernanceSystemToDTO(o)).ToList();
        }
        public async Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var perfomanceGovernanceSystemDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (perfomanceGovernanceSystemDto.TotalCount == 0)
                return null;
            return DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>.Create(perfomanceGovernanceSystemDto.Items, page, pageSize, perfomanceGovernanceSystemDto.TotalCount);
        }
        // Save or Update PgsAuditDetails
        public async Task<PerfomanceGovernanceSystemDto> SaveOrUpdateAsync(PerfomanceGovernanceSystemDto perfomanceGovernanceSystemDto, CancellationToken cancellationToken)
        {
            if (perfomanceGovernanceSystemDto == null) throw new ArgumentNullException(nameof(perfomanceGovernanceSystemDto));

            // Convert DTO to entity
            var perfomanceGovernanceSystemEntity = perfomanceGovernanceSystemDto.ToEntity();
            perfomanceGovernanceSystemEntity.Office = await _officeRepository.GetByIdAsync(perfomanceGovernanceSystemEntity.Office.Id, cancellationToken).ConfigureAwait(false);
            perfomanceGovernanceSystemEntity.PgsPeriod = await _pgsPeriodRepository.GetByIdAsync(perfomanceGovernanceSystemEntity.PgsPeriod.Id, cancellationToken).ConfigureAwait(false);

            if (perfomanceGovernanceSystemEntity.PgsDeliverables != null)
            {
                foreach (var deliverable in perfomanceGovernanceSystemEntity.PgsDeliverables)
                {
                    deliverable.Kra = await _kraRepository.GetByIdAsync(deliverable!.Kra!.Id, cancellationToken).ConfigureAwait(false);
                }
            }
            // Handle Save or Update
            var createdPerfomanceGovernanceSystem = await _repository.SaveOrUpdateAsync(perfomanceGovernanceSystemEntity, cancellationToken).ConfigureAwait(false);
            return new PerfomanceGovernanceSystemDto
            {
                Id = createdPerfomanceGovernanceSystem.Id,
                Remarks = createdPerfomanceGovernanceSystem.Remarks,
                PgsPeriod = new PgsPeriodDto
                {
                    Id = createdPerfomanceGovernanceSystem.PgsPeriod.Id,
                    StartDate = createdPerfomanceGovernanceSystem.PgsPeriod.StartDate,
                    EndDate = createdPerfomanceGovernanceSystem.PgsPeriod.EndDate
                },
                Office = new OfficeDto
                {
                    Id = createdPerfomanceGovernanceSystem.Office.Id,
                    Name = createdPerfomanceGovernanceSystem.Office.Name,
                    IsActive = createdPerfomanceGovernanceSystem.Office.IsActive
                },
                PgsReadinessRating = new PgsReadinessRatingDto
                {
                    Id = createdPerfomanceGovernanceSystem.PgsReadinessRating!.Id,
                    CompetenceToDeliver = createdPerfomanceGovernanceSystem.PgsReadinessRating.CompetenceToDeliver,
                    ResourceAvailability = createdPerfomanceGovernanceSystem.PgsReadinessRating.ResourceAvailability,
                    ConfidenceToDeliver = createdPerfomanceGovernanceSystem.PgsReadinessRating.ConfidenceToDeliver,
                },
                PgsDeliverables = createdPerfomanceGovernanceSystem.PgsDeliverables?.Select(deliverable => new PGSDeliverableDto
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
            if (dto is not PerfomanceGovernanceSystemDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
