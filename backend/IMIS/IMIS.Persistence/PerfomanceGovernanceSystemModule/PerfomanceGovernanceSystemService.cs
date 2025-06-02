using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsDeliverableModule;
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
        public PerfomanceGovernanceSystemService(IPerfomanceGovernanceSystemRepository repository, IOfficeRepository officeRepository, IPgsPeriodRepository pgsPeriodRepository, IKeyResultAreaRepository kraRepository, UserManager<User> userManager)
        {
            _repository = repository;
            _officeRepository = officeRepository;
            _pgsPeriodRepository = pgsPeriodRepository;
            _kraRepository = kraRepository;
            _userManager = userManager;
        }
        public async Task<List<PerfomanceGovernanceSystemDto>> GetAllAsyncFilterByPgsPeriod(long? pgsPeriodId, CancellationToken cancellationToken)
        {
            var systems = await _repository.GetAllAsyncFilterByPgsPeriod(pgsPeriodId, cancellationToken).ConfigureAwait(false);
            return systems.Select(ConvPerfomanceGovernanceSystemToDTO).ToList();
        }
        private PerfomanceGovernanceSystemDto ConvPerfomanceGovernanceSystemToDTO(PerfomanceGovernanceSystem perfomanceGovernanceSystem)
        {
            if (perfomanceGovernanceSystem == null) return null;

            return new PerfomanceGovernanceSystemDto
            {
                Id = perfomanceGovernanceSystem.Id,
                Remarks = perfomanceGovernanceSystem.Remarks,
                PercentDeliverables = perfomanceGovernanceSystem.PercentDeliverables,
                PgsStatus = perfomanceGovernanceSystem.PgsStatus,               
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
                    //KraId = deliverable.KraId,
                    Kra = deliverable.Kra != null ? new KeyResultAreaDto
                    {
                        Id = deliverable.Kra.Id,
                        Name = deliverable.Kra.Name,
                        Remarks = deliverable.Kra.Remarks
                    } : null, 
                    Remarks = deliverable.Remarks
                }).ToList() ?? new List<PGSDeliverableDto>(),
                 PgsSignatories = perfomanceGovernanceSystem.PgsSignatories?.Select(s => new PgsSignatoryDto
                 {
                     Id = s.Id,
                     PgsId = s.PgsId,
                     PgsSignatoryTemplateId = s.PgsSignatoryTemplateId,
                     SignatoryId = s.SignatoryId,
                     DateSigned = s.DateSigned,                    
                 }).ToList()
            };
        }

            private ReportPerfomanceGovernanceSystemDto ConvReportPerfomanceGovernanceSystemToDTO(PerfomanceGovernanceSystem perfomanceGovernanceSystem, List<User> users)
            {
                if (perfomanceGovernanceSystem == null) return null;

                return new ReportPerfomanceGovernanceSystemDto
                {
                    Id = perfomanceGovernanceSystem.Id,
                    Remarks = perfomanceGovernanceSystem.Remarks,
                    PercentDeliverables = perfomanceGovernanceSystem.PercentDeliverables,           
                    PgsPeriod = perfomanceGovernanceSystem.PgsPeriod != null ? new PgsPeriodDto
                    {
                        Id = perfomanceGovernanceSystem.PgsPeriod.Id,
                        StartDate = perfomanceGovernanceSystem.PgsPeriod.StartDate,
                        EndDate = perfomanceGovernanceSystem.PgsPeriod.EndDate,
                        Remarks = perfomanceGovernanceSystem.PgsPeriod.Remarks
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
                    PgsDeliverables = perfomanceGovernanceSystem.PgsDeliverables?.Select(deliverable => new ReportPGSDeliverableDto
                    {
                        Id = deliverable.Id,
                        IsDirect = deliverable.IsDirect,
                        DeliverableName = deliverable.DeliverableName,
                        ByWhen = deliverable.ByWhen,
                        PercentDeliverables = deliverable.PercentDeliverables,
                        Status = deliverable.Status,
                        RowVersion = deliverable.RowVersion,
                        KraId = deliverable.KraId,
                        Kra = deliverable.Kra != null ? new KeyResultAreaDto
                        {
                            Id = deliverable.Kra.Id,
                            Name = deliverable.Kra.Name,
                            Remarks = deliverable.Kra.Remarks
                        } : null,
                        Remarks = deliverable.Remarks
                    }).ToList() ?? new List<ReportPGSDeliverableDto>(),                
                    PgsSignatories = perfomanceGovernanceSystem.PgsSignatories?.Select(s =>
                    {
                        var user = users.FirstOrDefault(u => u.Id == s.SignatoryId); 

                        return new ReportPgsSignatoryDto
                        {
                            Id = s.Id,
                            PgsId = s.PgsId,
                            PgsSignatoryTemplateId = s.PgsSignatoryTemplateId,
                            SignatoryId = s.SignatoryId,
                            DateSigned = s.DateSigned,
                            PgsSignatoryTemplate = s.PgsSignatoryTemplate != null
                                ? new PgsSignatoryTemplateDto
                                {
                                    Id = s.PgsSignatoryTemplate.Id,
                                    SignatoryLabel = s.PgsSignatoryTemplate.SignatoryLabel,
                                }
                                : null,
                                User = user != null
                                ? new User
                                {
                                    Id = user.Id,
                                    FirstName = user.FirstName,
                                    MiddleName = user.MiddleName,
                                    LastName = user.LastName,
                                    Prefix = user.Prefix,
                                    Suffix = user.Suffix,
                                    Position = user.Position,                              
                                }
                                : null
                        };
                    }).ToList()
                };
            }
        public async Task<List<PerfomanceGovernanceSystemDto>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            //throw new NotImplementedException();
            var perfomanceGovernanceSystemDto = await _repository.GetByUserIdAsync(userId, cancellationToken).ConfigureAwait(false);
            return perfomanceGovernanceSystemDto?.Select(o => ConvPerfomanceGovernanceSystemToDTO(o)).ToList();
        }
        public async Task<PerfomanceGovernanceSystemDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var perfomanceGovernanceSystemDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return perfomanceGovernanceSystemDto != null ? ConvPerfomanceGovernanceSystemToDTO(perfomanceGovernanceSystemDto) : null;
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

            return ConvReportPerfomanceGovernanceSystemToDTO(perfomanceGovernanceSystem, users);
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
                    //KraId = deliverable.KraId,
                    Kra = deliverable.Kra != null ? new KeyResultAreaDto
                    {
                        Id = deliverable.Kra.Id,
                        Name = deliverable.Kra.Name,
                        Remarks = deliverable.Kra.Remarks
                    } : null,
                    Remarks = deliverable.Remarks
                }).ToList(),
                PgsSignatories = createdPerfomanceGovernanceSystem.PgsSignatories?.Select(s => new PgsSignatoryDto
                {
                    Id = s.Id,
                    PgsId = s.PgsId,
                    PgsSignatoryTemplateId = s.PgsSignatoryTemplateId,
                    SignatoryId = s.SignatoryId,
                    DateSigned = s.DateSigned
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
