using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Application.PgsDeliverableScoreHistoryModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Application.PgsSignatoryModule;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.OutputCaching;
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
        private readonly IPgsSignatoryTemplateService _signatoryTemplateService;

        public PerfomanceGovernanceSystemService(IPerfomanceGovernanceSystemRepository repository, 
            IOfficeRepository officeRepository, IPgsPeriodRepository pgsPeriodRepository, 
            IKeyResultAreaRepository kraRepository, UserManager<User> userManager, IPgsSignatoryTemplateService signatoryTemplateService)
        {
            _repository = repository;
            _officeRepository = officeRepository;
            _pgsPeriodRepository = pgsPeriodRepository;
            _kraRepository = kraRepository;
            _userManager = userManager;
            _signatoryTemplateService = signatoryTemplateService;
        }

        public async Task<List<PerfomanceGovernanceSystemDto>> GetAllAsyncFilterByPgsPeriod(long? pgsPeriodId, CancellationToken cancellationToken)
        {
            var systems = await _repository.GetAllAsyncFilterByPgsPeriod(pgsPeriodId, cancellationToken).ConfigureAwait(false);
            return systems.Select(ConvPerfomanceGovernanceSystemToDTO).ToList();
        }

        private PerfomanceGovernanceSystemDto ConvPerfomanceGovernanceSystemToDTO(PerfomanceGovernanceSystem perfomanceGovernanceSystem)
        {
            return new PerfomanceGovernanceSystemDto
            {
                Id = perfomanceGovernanceSystem.Id,
                Remarks = perfomanceGovernanceSystem.Remarks,
                PercentDeliverables = perfomanceGovernanceSystem.PercentDeliverables,
                PgsStatus = perfomanceGovernanceSystem.PgsStatus,
                PgsPeriod = new PgsPeriodDto
                {
                    Id = perfomanceGovernanceSystem.PgsPeriod.Id,
                    StartDate = perfomanceGovernanceSystem.PgsPeriod.StartDate,
                    EndDate = perfomanceGovernanceSystem.PgsPeriod.EndDate
                },
           
                Office = new OfficeDto
                {
                    Id = perfomanceGovernanceSystem.Office.Id,
                    Name = perfomanceGovernanceSystem.Office.Name,
                    IsActive = perfomanceGovernanceSystem.Office.IsActive,
                    OfficeTypeId = perfomanceGovernanceSystem.Office.OfficeTypeId,
                    ParentOfficeId = perfomanceGovernanceSystem.Office.ParentOfficeId
                },

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


        public async Task<PerfomanceGovernanceSystemDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgs = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pgs != null ? ConvPerfomanceGovernanceSystemToDTO(pgs) : null;
        }

     
        private ReportPerfomanceGovernanceSystemDto ConvReportPerfomanceGovernanceSystemToDTO(PerfomanceGovernanceSystem perfomanceGovernanceSystem, List<User> users)
            {             
                return new ReportPerfomanceGovernanceSystemDto
                {
                    Id = perfomanceGovernanceSystem.Id,
                    Remarks = perfomanceGovernanceSystem.Remarks,
                    PercentDeliverables = perfomanceGovernanceSystem.PercentDeliverables,           
                    PgsPeriod =  new PgsPeriodDto
                    {
                        Id = perfomanceGovernanceSystem.PgsPeriod.Id,
                        StartDate = perfomanceGovernanceSystem.PgsPeriod.StartDate,
                        EndDate = perfomanceGovernanceSystem.PgsPeriod.EndDate,
                        Remarks = perfomanceGovernanceSystem.PgsPeriod.Remarks
                    },

                    Office = new OfficeDto
                    {
                        Id = perfomanceGovernanceSystem.Office.Id,
                        Name = perfomanceGovernanceSystem.Office.Name,
                        IsActive = perfomanceGovernanceSystem.Office.IsActive,
                        OfficeTypeId = perfomanceGovernanceSystem.Office.OfficeTypeId,
                        ParentOfficeId = perfomanceGovernanceSystem.Office.ParentOfficeId
                    },
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
                        KraDescription = deliverable.KraDescription,
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
      
        private async Task<PerfomanceGovernanceSystemDto> ConvRecursivePerfomanceGovernanceSystemToDTO(
            PerfomanceGovernanceSystem pgs,
            string? currentUserId,
            CancellationToken cancellationToken)
        {
            var dto = new PerfomanceGovernanceSystemDto
            {
                Id = pgs.Id,
                Remarks = pgs.Remarks,
                PercentDeliverables = pgs.PercentDeliverables,
                PgsStatus = pgs.PgsStatus,
                IsDeleted = pgs.IsDeleted,
                RowVersion = pgs.RowVersion,
                PgsPeriod = new PgsPeriodDto
                {
                    Id = pgs.PgsPeriod.Id,
                    StartDate = pgs.PgsPeriod.StartDate,
                    EndDate = pgs.PgsPeriod.EndDate,
                    Remarks = pgs.PgsPeriod.Remarks,
                    IsDeleted = pgs.PgsPeriod.IsDeleted,
                    RowVersion = pgs.PgsPeriod.RowVersion
                },
                Office =  new OfficeDto
                {
                    Id = pgs.Office.Id,
                    Name = pgs.Office.Name,
                    OfficeTypeId = pgs.Office.OfficeTypeId,
                    ParentOfficeId = pgs.Office.ParentOfficeId,
                    IsActive = pgs.Office.IsActive,
                    IsDeleted = pgs.Office.IsDeleted,
                    RowVersion = pgs.Office.RowVersion
                },
                PgsSignatories = pgs.PgsSignatories?.Select(s => new PgsSignatoryDto
                {
                    Id = s.Id,
                    PgsId = s.PgsId,
                    PgsSignatoryTemplateId = s.PgsSignatoryTemplateId,
                    SignatoryId = s.SignatoryId,
                    DateSigned = s.DateSigned,
                    IsDeleted = s.IsDeleted,
                    RowVersion = s.RowVersion
                }).ToList(),

                PgsReadinessRating = pgs.PgsReadinessRating == null ? null : new PgsReadinessRatingDto
                {
                    Id = pgs.PgsReadinessRating.Id,
                    CompetenceToDeliver = pgs.PgsReadinessRating.CompetenceToDeliver,
                    ResourceAvailability = pgs.PgsReadinessRating.ResourceAvailability,
                    ConfidenceToDeliver = pgs.PgsReadinessRating.ConfidenceToDeliver,
                    TotalScore = pgs.PgsReadinessRating.TotalScore,
                    IsDeleted = pgs.PgsReadinessRating.IsDeleted,
                    RowVersion = pgs.PgsReadinessRating.RowVersion
                },

                PgsDeliverables = pgs.PgsDeliverables?.Select(d => new PGSDeliverableDto
                {
                    Id = d.Id,
                    KraId = d.KraId,
                    Kra = d.Kra == null ? null : new KeyResultAreaDto
                    {
                        Id = d.Kra.Id,
                        Name = d.Kra.Name,
                        Remarks = d.Kra.Remarks,
                        IsDeleted = d.Kra.IsDeleted,
                        RowVersion = d.Kra.RowVersion
                    },
                    KraDescription = d.KraDescription,
                    DeliverableName = d.DeliverableName,
                    ByWhen = d.ByWhen,
                    IsDirect = d.IsDirect,
                    PercentDeliverables = d.PercentDeliverables,
                    Status = d.Status,
                    Remarks = d.Remarks,
                    PgsDeliverableScoreHistory = d.PgsDeliverableScoreHistory?.Select(h => new PgsDeliverableScoreHistoryDto
                    {
                        Id = h.Id,
                        PgsDeliverableId = h.PgsDeliverableId,
                        Date = h.Date,
                        Score = h.Score,
                        IsDeleted = h.IsDeleted,
                        RowVersion = h.RowVersion
                    }).ToList(),
                    IsDeleted = d.IsDeleted,
                    RowVersion = d.RowVersion
                }).ToList()
            };
           
            if (!string.IsNullOrEmpty(currentUserId))
            {
                dto.ForSignature = await IsUserNextSignatoryAsync(pgs, currentUserId, cancellationToken);
            }

            return dto;
        }

        public async Task<List<PerfomanceGovernanceSystemDto>> GetByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            var records = await _repository.GetByUserIdAsync(userId, cancellationToken).ConfigureAwait(false);

            var result = new List<PerfomanceGovernanceSystemDto>();

            if (records == null)
                return result;

            foreach (var pgs in records)
            {
                cancellationToken.ThrowIfCancellationRequested();

                var dto = await ConvRecursivePerfomanceGovernanceSystemToDTO(pgs, userId, cancellationToken);
                result.Add(dto);
            }

            return result;
        }

        private async Task<bool> IsUserNextSignatoryAsync(
        PerfomanceGovernanceSystem pgs,
        string userId,
        CancellationToken cancellationToken)
        {
            var templates = await _signatoryTemplateService.GetAllAsync(cancellationToken);

            var orderedTemplates = templates!
                .Where(t => t.OfficeId == pgs.OfficeId && t.IsActive)
                .OrderBy(t => t.OrderLevel)
                .ToList();
            foreach (var template in orderedTemplates)
            {
                bool isAlreadySigned = pgs.PgsSignatories?.Any(s =>
                    s.PgsSignatoryTemplateId == template.Id &&
                    s.DateSigned != null) ?? false;

                if (!isAlreadySigned)
                {
                 
                    return template.DefaultSignatoryId == userId;
                }
            }

            return false;
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
                    IsActive = createdPerfomanceGovernanceSystem.Office.IsActive,
                    OfficeTypeId = createdPerfomanceGovernanceSystem.Office.OfficeTypeId,
                    ParentOfficeId = createdPerfomanceGovernanceSystem.Office.ParentOfficeId
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
