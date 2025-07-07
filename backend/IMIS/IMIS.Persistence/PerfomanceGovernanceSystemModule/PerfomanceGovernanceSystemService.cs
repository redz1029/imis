using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsDeliverableScoreHistoryModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Application.PgsSignatoryModule;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsModule
{
    public class PerfomanceGovernanceSystemService : IPerfomanceGovernanceSystemService
    {
        private readonly IPerfomanceGovernanceSystemRepository _repository;
        private readonly IOfficeRepository _officeRepository;
        private readonly IPgsPeriodRepository _pgsPeriodRepository;
        private readonly IKeyResultAreaRepository _kraRepository;
        private readonly UserManager<User> _userManager;
        private readonly IPgsSignatoryTemplateRepository _signatoryTemplateRepository;

        public PerfomanceGovernanceSystemService(IPerfomanceGovernanceSystemRepository repository, 
            IOfficeRepository officeRepository, IPgsPeriodRepository pgsPeriodRepository, 
            IKeyResultAreaRepository kraRepository, UserManager<User> userManager, IPgsSignatoryTemplateRepository signatoryTemplateRepository)
        {
            _repository = repository;
            _officeRepository = officeRepository;
            _pgsPeriodRepository = pgsPeriodRepository;
            _kraRepository = kraRepository;
            _userManager = userManager;
            _signatoryTemplateRepository = signatoryTemplateRepository;
        }

        public async Task<List<PerfomanceGovernanceSystemDto>> GetAllAsyncFilterByPgsPeriod(long? pgsPeriodId, CancellationToken cancellationToken)
        {
            var systems = await _repository.GetAllAsyncFilterByPgsPeriod(pgsPeriodId, cancellationToken).ConfigureAwait(false);
            return systems.Select(e => new PerfomanceGovernanceSystemDto(e)).ToList();
        }


        public async Task<PerfomanceGovernanceSystemDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgs = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pgs != null ? new PerfomanceGovernanceSystemDto(pgs) : null;
        }

        public async Task<List<PerfomanceGovernanceSystemDto>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            var records = await _repository.GetByUserIdAsync(userId, cancellationToken).ConfigureAwait(false);

            var result = new List<PerfomanceGovernanceSystemDto>();

            if (records == null)
                return result;

            foreach (var pgs in records)
            {
                cancellationToken.ThrowIfCancellationRequested();

                var dto = new PerfomanceGovernanceSystemDto(pgs)
                {
                    ForSignature = await IsUserNextSignatoryAsync(pgs, userId, cancellationToken).ConfigureAwait(false)
                };
                result.Add(dto);
            }

            return result;
        }

        private async Task<bool> IsUserNextSignatoryAsync(
        PerfomanceGovernanceSystem pgs,
        string userId,
        CancellationToken cancellationToken)
        {
            var currentStatus = pgs.PgsSignatories?.LastOrDefault();
            if (currentStatus == null) // Currently saved as draft
                return false;

            // Try to get custom template or specific template of an office.
            // Basically if the office has it's own signatory workflow that differs on it's Service/Parent
            var signatoryTemplates = await _signatoryTemplateRepository
                .GetSignatoryTemplateByOfficeIdAsync(pgs.OfficeId, cancellationToken)
                .ConfigureAwait(false);

            if(signatoryTemplates.Count == 0)
            {
                // Get the root parent office.
                var office = await _officeRepository
                    .GetRootParentOffice(pgs.Office, cancellationToken)
                    .ConfigureAwait(false);

                // retrieve the template for services.
                signatoryTemplates = await _signatoryTemplateRepository
                    .GetSignatoryTemplateByOfficeIdAsync(office.Id, cancellationToken)
                    .ConfigureAwait(false);
            }

            var currentTemplate = currentStatus.PgsSignatoryTemplate 
                ?? await _signatoryTemplateRepository.GetByIdAsync(currentStatus.PgsSignatoryTemplateId, cancellationToken);

            var nextTemplate = signatoryTemplates.Where(e => e.OrderLevel == (currentTemplate.OrderLevel + 1)).FirstOrDefault();

            return nextTemplate?.DefaultSignatoryId == userId;
        }

        public async Task<ReportPerfomanceGovernanceSystemDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var perfomanceGovernanceSystem = await _repository.ReportGetByIdAsync(id, cancellationToken).ConfigureAwait(false);

            if (perfomanceGovernanceSystem == null) return null;          
            var signatoryIds = perfomanceGovernanceSystem.PgsSignatories?
                .Select(s => s.SignatoryId)
                .Distinct()
                .ToList() ?? new List<string>();

            // Fetch user details
            var users = await _userManager.Users
             .Where(u => signatoryIds.Contains(u.Id))
             .ToListAsync(cancellationToken); 

            return new ReportPerfomanceGovernanceSystemDto(perfomanceGovernanceSystem, users);
        }
        public async Task<List<PerfomanceGovernanceSystemDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var perfomanceGovernanceSystemDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return perfomanceGovernanceSystemDto?.Select(o => new PerfomanceGovernanceSystemDto(o)).ToList();
        }
        public async Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var perfomanceGovernanceSystemDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (perfomanceGovernanceSystemDto.TotalCount == 0)
                return null;
            return DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>.Create(perfomanceGovernanceSystemDto.Items, page, pageSize, perfomanceGovernanceSystemDto.TotalCount);
        }
        public async Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetPaginatedPgsPeriodIdAsync(long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var perfomanceGovernanceSystemDto = await _repository.GetPaginatedPgsPeriodIdAsync(pgsPeriodId, page, pageSize, cancellationToken).ConfigureAwait(false);
            if (perfomanceGovernanceSystemDto.TotalCount == 0)
                return null;
            return DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>.Create(perfomanceGovernanceSystemDto.Items, page, pageSize, perfomanceGovernanceSystemDto.TotalCount);
        }
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
                PercentDeliverables = createdPerfomanceGovernanceSystem.PercentDeliverables,
                PgsStatus = createdPerfomanceGovernanceSystem.PgsStatus,
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
                    IsActive = createdPerfomanceGovernanceSystem.Office.IsActive,
                    OfficeTypeId = createdPerfomanceGovernanceSystem.Office.OfficeTypeId,
                    ParentOfficeId = createdPerfomanceGovernanceSystem.Office.ParentOfficeId
                },
                PgsReadinessRating = createdPerfomanceGovernanceSystem.PgsReadinessRating != null ? new PgsReadinessRatingDto
                {
                    Id = createdPerfomanceGovernanceSystem.PgsReadinessRating!.Id,
                    CompetenceToDeliver = createdPerfomanceGovernanceSystem.PgsReadinessRating.CompetenceToDeliver,
                    ResourceAvailability = createdPerfomanceGovernanceSystem.PgsReadinessRating.ResourceAvailability,
                    ConfidenceToDeliver = createdPerfomanceGovernanceSystem.PgsReadinessRating.ConfidenceToDeliver,
                } : null,
                PgsDeliverables = createdPerfomanceGovernanceSystem.PgsDeliverables?.Select(deliverable => new PGSDeliverableDto
                {
                    Id = deliverable.Id,
                    IsDirect = deliverable.IsDirect,
                    DeliverableName = deliverable.DeliverableName,
                    ByWhen = deliverable.ByWhen,
                    PercentDeliverables = deliverable.PercentDeliverables,
                    Status = deliverable.Status,
                    RowVersion = deliverable.RowVersion,
                    KraDescription = deliverable.KraDescription,
                    Kra = deliverable.Kra != null ? new KeyResultAreaDto
                    {
                        Id = deliverable.Kra.Id,
                        Name = deliverable.Kra.Name,
                        Remarks = deliverable.Kra.Remarks
                    } : null,
                    Remarks = deliverable.Remarks,
                    PgsDeliverableScoreHistory = deliverable.PgsDeliverableScoreHistory?.Select(pgsDeliverableScoreHistoryDto => new PgsDeliverableScoreHistoryDto
                    {
                        Id = pgsDeliverableScoreHistoryDto.Id,
                        PgsDeliverableId = pgsDeliverableScoreHistoryDto.PgsDeliverableId,
                        Date = pgsDeliverableScoreHistoryDto.Date,
                        Score = pgsDeliverableScoreHistoryDto.Score,

                    }).ToList()
                }).ToList(),
                PgsSignatories = createdPerfomanceGovernanceSystem.PgsSignatories?.Select(s => new PgsSignatoryDto
                {
                    Id = s.Id,
                    PgsId = s.PgsId,
                    PgsSignatoryTemplateId = s.PgsSignatoryTemplateId,
                    SignatoryId = s.SignatoryId,
                    DateSigned = s.DateSigned,
                   
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
