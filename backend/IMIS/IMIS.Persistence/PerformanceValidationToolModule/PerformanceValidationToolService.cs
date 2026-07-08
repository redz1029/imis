using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PerformanceValidationToolConclusionModule;
using IMIS.Application.PerformanceValidationToolDeliverableFindingsModule;
using IMIS.Application.PerformanceValidationToolModule;
using IMIS.Application.PerformanceValidationToolObjectivesModule;
using IMIS.Application.PerformanceValidationToolSignatoryModule;
using IMIS.Application.PerformanceValidationToolSignatoryTemplateModule;
using IMIS.Application.PerformanceValidationToolValidatorsModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using PgsStatus = IMIS.Application.PerfomanceGovernanceSystemModule.PgsStatus;

namespace IMIS.Persistence.PerformanceValidationToolModule
{
    public class PerformanceValidationToolService : IPerformanceValidationToolService
    {
        private readonly IPerformanceValidationToolRepository _repository;
        private readonly IPerformanceValidationToolSignatoryTemplateRepository _signatoryTemplateRepository;
        private readonly IOfficeRepository _officeRepository;
        private readonly UserManager<User> _userManager;
        public PerformanceValidationToolService(IPerformanceValidationToolRepository repository,
            IPerformanceValidationToolSignatoryTemplateRepository signatoryTemplateRepository, UserManager<User> userManager)
        {
            _repository = repository;
            _signatoryTemplateRepository = signatoryTemplateRepository;
            _userManager = userManager;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entities == null)
                return false;

            entities.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        private async Task<PerformanceValidationToolDto> ProcessSignatoriesAsync(PerformanceValidationTool tool, string userId, CancellationToken cancellationToken)
        {
            var dto = new PerformanceValidationToolDto(tool)
            {
                PvtSignatories = new List<PerformanceValidationToolSignatoryDto>()
            };

            bool hasSavedSignatories = tool.PvtSignatories != null &&  tool.PvtSignatories.Any(s => s.Id > 0);

            dto.IsDraft = !hasSavedSignatories;

            var templates = await GetInheritedSignatoryTemplatesAsync(tool.Office!, cancellationToken);

            var userIds = new List<string>();

            if (tool.Office?.UserOffices != null)
            {
                userIds.AddRange(tool.Office.UserOffices.Where(x => x.IsOfficeHead).Select(x => x.UserId));
            }

            userIds.AddRange(templates.Where(t => !string.IsNullOrWhiteSpace(t.DefaultSignatoryId)).Select(t => t.DefaultSignatoryId!));

            if (tool.PvtSignatories != null)
            {
                userIds.AddRange(tool.PvtSignatories.Where(s => s.SignatoryId != null).Select(s => s.SignatoryId!));
            }

            userIds = userIds.Distinct().ToList();

            var usersDict = await _userManager.Users.Where(u => userIds.Contains(u.Id)).ToDictionaryAsync(u => u.Id, cancellationToken);

            string GetFullName(string id)
            {
                return usersDict.TryGetValue(id, out var u) ? string.Join(" ", new[]
                { u.FirstName, 
                  u.LastName 
                } 
                .Where(x => !string.IsNullOrWhiteSpace(x))) : "";
            }
       
            foreach (var s in tool.PvtSignatories ?? [])
            {
                dto.PvtSignatories.Add(new PerformanceValidationToolSignatoryDto
                {
                    Id = s.Id,
                    PerformanceValidationToolId = tool.Id,
                    PerformanceValidationToolSignatoryTemplateId = s.PerformanceValidationToolSignatoryTemplateId,
                    SignatoryId = s.SignatoryId,
                    SignatoryName = GetFullName(s.SignatoryId),
                    DateSigned = s.DateSigned,
                    OrderLevel = 0,
                    Status = s.DateSigned != default ? PgsStatus.Prepared : PgsStatus.Pending
                });
            }
       
            foreach (var t in templates.OrderBy(x => x.OrderLevel))
            {
                bool exists = dto.PvtSignatories.Any(x => x.PerformanceValidationToolSignatoryTemplateId == t.Id);

                if (exists)
                    continue;

                dto.PvtSignatories.Add(new PerformanceValidationToolSignatoryDto
                {
                    Id = 0,
                    PerformanceValidationToolId = tool.Id,
                    PerformanceValidationToolSignatoryTemplateId = t.Id,
                    SignatoryId = t.DefaultSignatoryId!,
                    SignatoryName = GetFullName(t.DefaultSignatoryId!),
                    Label = t.SignatoryLabel,
                    OrderLevel = t.OrderLevel,
                    Status = PgsStatus.Pending,
                    IsNextStatus = false
                });
            }
         
            var firstSignatory = dto.PvtSignatories.Where(x => x.Id > 0 && x.DateSigned != default).OrderBy(x => x.DateSigned).FirstOrDefault();

            if (firstSignatory != null)
            {
                firstSignatory.PerformanceValidationToolSignatoryTemplateId = null;
            }
        
            dto.PvtSignatories = dto.PvtSignatories.OrderBy(x => x.OrderLevel).ToList();

            var next = dto.PvtSignatories.Where(x => x.Status == PgsStatus.Pending).OrderBy(x => x.OrderLevel).FirstOrDefault();

            if (next != null) next.IsNextStatus = true;

            return dto;
        }
        public async Task<PerformanceValidationToolDto?>GetByUserIdAndPerformanceValidationToolIdAsync(string userId, long performanceValidationToolId,  CancellationToken cancellationToken)
        {
            var tool = await _repository.GetByUserIdAndPerformanceValidationToolIdAsync(performanceValidationToolId, cancellationToken);

            if (tool == null)
                return null;        

            var dto = await ProcessSignatoriesAsync(tool, userId, cancellationToken);

            var inChildOffice = tool.Office?.UserOffices?.Any(x => x.UserId == userId) == true;

            var inParentOffice = tool.Office?.ParentOffice?.UserOffices?.Any(x => x.UserId == userId) == true;

            var isNextSignatory = dto.PvtSignatories?.Any(x => x.SignatoryId == userId && x.IsNextStatus) == true;

            if (!inChildOffice && !inParentOffice &&  !isNextSignatory)
            {
                return null;
            }   

            return dto;
        }

        public async Task<List<PerformanceValidationToolDto>?> GetAllPgsIdTool(long? performanceGovernanceSystemId, CancellationToken cancellationToken)
        {
            var data = await _repository.GetAllPgsIdTool(performanceGovernanceSystemId, cancellationToken).ConfigureAwait(false);

            return data?.Select(a => new PerformanceValidationToolDto(a)).ToList();
        }
        public async Task<List<PerformanceValidationToolDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var performanceValidationToolDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (performanceValidationToolDto == null)
                return null;

            return performanceValidationToolDto.Select(d => new PerformanceValidationToolDto(d)).ToList();
        }
       
        public async Task<PerformanceValidationToolDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByPvtIdAsync(id, cancellationToken).ConfigureAwait(false);

            if (entity == null)
            {
                return null;
            }

            var dto = new PerformanceValidationToolDto(entity);

            if (!string.IsNullOrWhiteSpace(entity.OfficeHeadUserId))
            {
                var officeHead = await _userManager.FindByIdAsync(entity.OfficeHeadUserId);

                if (officeHead != null)
                {
                    dto.OfficeHeadName = string.Join(" ", new[]
                    {
                        officeHead.FirstName,
                        officeHead.MiddleName,
                        officeHead.LastName,
                        officeHead.Suffix
                    }.Where(s => !string.IsNullOrWhiteSpace(s)));
                }
            }

            // Validators
            dto.Validators = entity.Validators?.Select(x => new PerformanceValidationToolValidatorsDto
            {
                Id = x.Id,
                PerformanceValidationToolId = x.PerformanceValidationToolId,
                AuditorId = x.AuditorId,
                AuditorName = string.Join(" ", new[]
                {
                    x.Auditor?.User?.FirstName,
                    x.Auditor?.User?.MiddleName,
                    x.Auditor?.User?.LastName,
                    x.Auditor?.User?.Suffix
                }.Where(s => !string.IsNullOrWhiteSpace(s))),
                PostingDate = x.PostingDate
            })
            .ToList();

            // Deliverable Findings
            dto.DeliverableFindings = entity.DeliverableFindings?.Select(x => new PerformanceValidationToolDeliverableFindingsDto
            {
                Id = x.Id,
                PerformanceValidationToolId = x.PerformanceValidationToolId,  
                PgsDeliverableId = x.PgsDeliverableId,
                DeliverableName = x.PgsDeliverable?.DeliverableName,
                Findings = x.Findings,
                IsNC = x.IsNC,
                IsOFI = x.IsOFI,
                PostingDate = x.PostingDate
            })
            .ToList();

            return dto;
        }
        public async Task<ReportPerformanceValidationToolDto?> ReportGetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByPvtIdAsync(id, cancellationToken).ConfigureAwait(false);

            if (entity == null)
            {
                return null;
            }

            var dto = new ReportPerformanceValidationToolDto(entity);

            if (!string.IsNullOrWhiteSpace(entity.OfficeHeadUserId))
            {
                var officeHead = await _userManager.FindByIdAsync(entity.OfficeHeadUserId);

                if (officeHead != null)
                {
                    dto.OfficeHeadName = string.Join(" ", new[]
                    {
                        officeHead.FirstName,
                        officeHead.MiddleName,
                        officeHead.LastName,
                        officeHead.Suffix
                    }.Where(s => !string.IsNullOrWhiteSpace(s)));
                }
            }

            // Validators
            dto.Validators = entity.Validators?.Select(x => new PerformanceValidationToolValidatorsDto
            {
                Id = x.Id,
                PerformanceValidationToolId = x.PerformanceValidationToolId,
                AuditorId = x.AuditorId,
                AuditorName = string.Join(" ", new[]
                {
                    x.Auditor?.User?.FirstName,
                    x.Auditor?.User?.MiddleName,
                    x.Auditor?.User?.LastName,
                    x.Auditor?.User?.Suffix
                }.Where(s => !string.IsNullOrWhiteSpace(s))),
                PostingDate = x.PostingDate
            })
            .ToList();

            // Deliverable Findings
            dto.DeliverableFindings = entity.DeliverableFindings?.Select(x => new PerformanceValidationToolDeliverableFindingsDto
            {
                Id = x.Id,
                PerformanceValidationToolId = x.PerformanceValidationToolId,  
                PgsDeliverableId = x.PgsDeliverableId,
                DeliverableName = x.PgsDeliverable?.DeliverableName,
                Findings = x.Findings,
                IsNC = x.IsNC,
                IsOFI = x.IsOFI,
                PostingDate = x.PostingDate
            })
            .ToList();

            return dto;
        }


        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
        where TEntity : Entity<TId>
        {
            if (dto is not PerformanceValidationToolDto pvtDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            var db = _repository.GetDbContext();

            PerformanceValidationTool pvtEntity;

            if (pvtDto.Id > 0)
            {
                // UPDATE
                pvtEntity = await db.Set<PerformanceValidationTool>().FirstOrDefaultAsync(x => x.Id == pvtDto.Id, cancellationToken) ?? throw new Exception($"PerformanceValidationTool {pvtDto.Id} not found.");
                pvtEntity.PerformanceValidationToolPeriodId = pvtDto.PerformanceValidationToolPeriodId;
                pvtEntity.OfficeId = pvtDto.OfficeId;
                pvtEntity.OfficeHeadUserId = pvtDto.OfficeHeadUserId ?? string.Empty;
                pvtEntity.ValidateDate = pvtDto.ValidateDate;
                pvtEntity.Comment = pvtDto.Comment;
                pvtEntity.PostingDate = pvtDto.PostingDate;
                pvtEntity.PerformanceGovernanceSystemId = pvtDto.PerformanceGovernanceSystemId;
                db.Set<PerformanceValidationTool>().Update(pvtEntity);
            }
            else
            {
                // INSERT
                pvtEntity = pvtDto.ToEntity();
                pvtEntity.Objectives = null;
                pvtEntity.Conclusion = null;
                pvtEntity.Validators = null;
                pvtEntity.DeliverableFindings = null;
                pvtEntity.PvtSignatories = null;
                db.Set<PerformanceValidationTool>().Add(pvtEntity);
            }

            await db.SaveChangesAsync(cancellationToken);

            if (pvtEntity.Id <= 0)
                throw new Exception("Parent record was not saved.");

            await SaveChildRecordsAsync(pvtDto, pvtEntity.Id, cancellationToken);
        }
        private async Task SaveChildRecordsAsync(PerformanceValidationToolDto dto, long performanceValidationToolId, CancellationToken cancellationToken)
        {
            await SaveObjectivesAsync(dto.Objectives, performanceValidationToolId, cancellationToken);

            await SaveConclusionAsync(dto.Conclusion, performanceValidationToolId, cancellationToken);

            await SaveValidatorsAsync(dto.Validators, performanceValidationToolId, cancellationToken);

            await SaveDeliverableFindingsAsync(dto.DeliverableFindings, performanceValidationToolId, cancellationToken);
                     
        }

        private async Task SaveObjectivesAsync(PerformanceValidationToolObjectivesDto? dto, long performanceValidationToolId, CancellationToken cancellationToken)
        {
            if (dto == null)
                return;

            var db = _repository.GetDbContext();

            var existing = await db.Set<PerformanceValidationToolObjectives>().FirstOrDefaultAsync(x => x.PerformanceValidationToolId == performanceValidationToolId, cancellationToken);

            if (existing == null)
            {
                dto.PerformanceValidationToolId = performanceValidationToolId;

                db.Set<PerformanceValidationToolObjectives>().Add(dto.ToEntity());
            }
            else
            {
                existing.IsAssessmentCompliant = dto.IsAssessmentCompliant;
                existing.IsImplementationVerified = dto.IsImplementationVerified;
                existing.IsDeliverableProgressMonitored = dto.IsDeliverableProgressMonitored;
                existing.HasOpportunitiesForImprovement = dto.HasOpportunitiesForImprovement;
                existing.IsValidated = dto.IsValidated;
                existing.PostingDate = dto.PostingDate;
            }

            await db.SaveChangesAsync(cancellationToken);
        }
        private async Task SaveConclusionAsync(PerformanceValidationToolConclusionDto? dto, long performanceValidationToolId, CancellationToken cancellationToken)
        {
            if (dto == null)
                return;

            var db = _repository.GetDbContext();

            var existing = await db.Set<PerformanceValidationToolConclusion>().FirstOrDefaultAsync(x => x.PerformanceValidationToolId == performanceValidationToolId, cancellationToken);

            if (existing == null)
            {
                dto.PerformanceValidationToolId = performanceValidationToolId;

                db.Set<PerformanceValidationToolConclusion>().Add(dto.ToEntity());
            }
            else
            {
                existing.IsCompliant = dto.IsCompliant;
                existing.IsImprovement = dto.IsImprovement;
                existing.IsPartial = dto.IsPartial;
                existing.IsCritical = dto.IsCritical;
                existing.PostingDate = dto.PostingDate;
            }

            await db.SaveChangesAsync(cancellationToken);
        }
        private async Task SaveValidatorsAsync(List<PerformanceValidationToolValidatorsDto>? dtos, long performanceValidationToolId, CancellationToken cancellationToken)
        {
            if (dtos == null)
                return;

            var db = _repository.GetDbContext();

            var existingRecords = await db.Set<PerformanceValidationToolValidators>().Where(x => x.PerformanceValidationToolId == performanceValidationToolId).ToListAsync(cancellationToken);

            var incomingIds = dtos.Where(x => x.Id > 0).Select(x => x.Id).ToHashSet();

            var toDelete = existingRecords.Where(x => !incomingIds.Contains(x.Id)).ToList();

            if (toDelete.Any())db.Set<PerformanceValidationToolValidators>().RemoveRange(toDelete);

            foreach (var dto in dtos)
            {
                dto.PerformanceValidationToolId = performanceValidationToolId;

                if (dto.Id == 0)
                {
                    db.Set<PerformanceValidationToolValidators>().Add(dto.ToEntity());
                }
                else
                {
                    var existing = existingRecords.FirstOrDefault(x => x.Id == dto.Id);

                    if (existing != null)
                    {
                        existing.AuditorId = dto.AuditorId;
                        existing.PostingDate = dto.PostingDate;
                    }
                }
            }

            await db.SaveChangesAsync(cancellationToken);
        }
        private async Task SaveDeliverableFindingsAsync(List<PerformanceValidationToolDeliverableFindingsDto>? dtos, long performanceValidationToolId, CancellationToken cancellationToken)
        {
            if (dtos == null)
                return;

            var db = _repository.GetDbContext();

            var existingRecords = await db.Set<PerformanceValidationToolDeliverableFindings>().Where(x => x.PerformanceValidationToolId == performanceValidationToolId).ToListAsync(cancellationToken);

            var incomingIds = dtos.Where(x => x.Id > 0).Select(x => x.Id).ToHashSet();

            var toDelete = existingRecords.Where(x => !incomingIds.Contains(x.Id)).ToList();

            if (toDelete.Any())db.Set<PerformanceValidationToolDeliverableFindings>().RemoveRange(toDelete);

            foreach (var dto in dtos)
            {
                dto.PerformanceValidationToolId = performanceValidationToolId;

                if (dto.Id == 0)
                {
                    db.Set<PerformanceValidationToolDeliverableFindings>().Add(dto.ToEntity());
                }
                else
                {
                    var existing = existingRecords.FirstOrDefault(x => x.Id == dto.Id);

                    if (existing != null)
                    {
                        existing.PgsDeliverableId = dto.PgsDeliverableId;
                        existing.Findings = dto.Findings;
                        existing.IsNC = dto.IsNC;
                        existing.IsOFI = dto.IsOFI;
                        existing.PostingDate = dto.PostingDate;
                    }
                }
            }

            await db.SaveChangesAsync(cancellationToken);
        }

        private async Task SaveSignatoriesAsync(List<PerformanceValidationToolSignatoryDto>? dtos, long performanceValidationToolId, CancellationToken cancellationToken)
        {
            if (dtos == null || !dtos.Any())
                return;

            var db = _repository.GetDbContext();

            var existing = await db.Set<PerformanceValidationToolSignatory>().Where(x => x.PerformanceValidationToolId == performanceValidationToolId).ToListAsync(cancellationToken);

            foreach (var dto in dtos)
            {
                dto.PerformanceValidationToolId = performanceValidationToolId;

                var dbRow = dto.Id > 0 ? existing.FirstOrDefault(x => x.Id == dto.Id) : null;

                if (dbRow != null)
                {
                    dbRow.SignatoryId = dto.SignatoryId;
                    dbRow.DateSigned = dto.DateSigned;
                    dbRow.PerformanceValidationToolSignatoryTemplateId = dto.PerformanceValidationToolSignatoryTemplateId;

                    continue;
                }

                bool isSigned = dto.DateSigned != default && !string.IsNullOrWhiteSpace(dto.SignatoryId);

                if (!isSigned)
                    continue;

                db.Set<PerformanceValidationToolSignatory>().Add(new PerformanceValidationToolSignatory
                {
                    Id = 0,
                    PerformanceValidationToolId = performanceValidationToolId,
                    PerformanceValidationToolSignatoryTemplateId = dto.PerformanceValidationToolSignatoryTemplateId,
                    SignatoryId = dto.SignatoryId,
                    DateSigned = dto.DateSigned
                });
            }

            await db.SaveChangesAsync(cancellationToken);
        }
             
        //========== Okay narin itooo
        public async Task<PerformanceValidationToolDto> Submit(PerformanceValidationToolDto dto, string userId, CancellationToken cancellationToken)
        {
            var existing = await _repository.GetWithIncludesAsync(dto.Id, cancellationToken) ?? throw new Exception("Not found");

            var processed = await ProcessSignatoriesAsync(existing, userId, cancellationToken);

            var current = processed.PvtSignatories?
                .Where(x => x.IsNextStatus)
                .OrderBy(x => x.OrderLevel)
                .FirstOrDefault();

            if (current != null)
            {
                current.SignatoryId = userId;
                current.DateSigned = DateTime.UtcNow;
                current.Status = PgsStatus.Prepared;
                current.IsNextStatus = false;
              
                var signedCount = existing.PvtSignatories?.Count() ?? 0;

                bool isOfficeHeadSign = signedCount == 0;
                bool isRecommendedSign = signedCount == 1;
              
                if (isOfficeHeadSign || isRecommendedSign)
                {
                    current.PerformanceValidationToolSignatoryTemplateId = null;
                }
            }

            await SaveSignatoriesAsync(processed.PvtSignatories, dto.Id, cancellationToken);

            await SaveOrUpdateAsync(dto, cancellationToken);

            var refreshed = await _repository.GetWithIncludesAsync(dto.Id, cancellationToken);

            return await ProcessSignatoriesAsync(refreshed!, userId, cancellationToken);
        }

        private async Task<IEnumerable<PerformanceValidationToolSignatoryTemplate>> GetInheritedSignatoryTemplatesAsync(Office office, CancellationToken cancellationToken)
        {
            if (office == null)
                return Enumerable.Empty<PerformanceValidationToolSignatoryTemplate>();
          
            var templates = await _signatoryTemplateRepository.GetSignatoryTemplateByOfficeIdAsync(office.Id, cancellationToken);

            if (templates != null && templates.Any())
            {
                return templates.OrderBy(t => t.OrderLevel).ToList();
            }
         
            Office? parentOffice = null;

            if (office.ParentOffice != null)
            {
                parentOffice = office.ParentOffice;
            }
            else if (office.ParentOfficeId != null)
            {
                parentOffice = await _repository.GetDbContext().Set<Office>().FirstOrDefaultAsync(x => x.Id == office.ParentOfficeId, cancellationToken);
            }

            if (parentOffice == null)
            {
                try
                {
                    parentOffice = await _officeRepository.GetRootParentOffice(office, cancellationToken);
                }
                catch
                {
                    parentOffice = null;
                }
            }

            if (parentOffice == null) 
                return Enumerable.Empty<PerformanceValidationToolSignatoryTemplate>();
         
            var parentTemplates = await GetInheritedSignatoryTemplatesAsync(parentOffice,  cancellationToken);
           
            var clonedTemplates = parentTemplates.Where(x => x != null).Select(t => new PerformanceValidationToolSignatoryTemplate
            {
                Id = t.Id,
                OfficeId = t.OfficeId,
                SignatoryLabel = t.SignatoryLabel,
                DefaultSignatoryId = t.DefaultSignatoryId,
                OrderLevel = t.OrderLevel,
                IsActive = t.IsActive,
                IsDeleted = t.IsDeleted,
                RowVersion = t.RowVersion,
                Status = t.Status
            })
            .ToList();

            return clonedTemplates.OrderBy(t => t.OrderLevel).ToList();
        }      
    }
}
 