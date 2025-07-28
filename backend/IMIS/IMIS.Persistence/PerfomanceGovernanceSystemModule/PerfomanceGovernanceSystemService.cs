using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
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
        private readonly ImisDbContext _dbContext;

        public PerfomanceGovernanceSystemService(IPerfomanceGovernanceSystemRepository repository, 
            IOfficeRepository officeRepository, IPgsPeriodRepository pgsPeriodRepository, 
            IKeyResultAreaRepository kraRepository, UserManager<User> userManager, IPgsSignatoryTemplateRepository signatoryTemplateRepository, ImisDbContext dbContext)
        {
            _repository = repository;
            _officeRepository = officeRepository;
            _pgsPeriodRepository = pgsPeriodRepository;
            _kraRepository = kraRepository;
            _userManager = userManager;
            _signatoryTemplateRepository = signatoryTemplateRepository;
            _dbContext = dbContext;
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

        public async Task<PerfomanceGovernanceSystemDto?> GetByUserIdAndPgsIdAsync(string userId, int pgsId, CancellationToken cancellationToken)
        {
            var pgs = await _repository.GetByUserIdAndPgsIdAsync(userId, pgsId, cancellationToken);
            if (pgs == null) return null;

            var dto = await ProcessPGSSignatories(pgs, userId, cancellationToken);
            return dto;
        }

        private async Task<PerfomanceGovernanceSystemDto> ProcessPGSSignatories(
        PerfomanceGovernanceSystem pgs,
        string userId,
        CancellationToken cancellationToken)
        {
            var dto = new PerfomanceGovernanceSystemDto(pgs);

            bool hasDisapproved = pgs.PgsDeliverables?.Any(d => d.IsDisapproved) ?? false;

            if (hasDisapproved)
            {               
                if (pgs.PgsSignatories?.Any() == true)
                {
                    _dbContext.PgsSignatory.RemoveRange(pgs.PgsSignatories);
                    await _dbContext.SaveChangesAsync(cancellationToken);
                }
               
                var templates = (await GetSignatoryTemplates(pgs.Office, cancellationToken))
                    .OrderBy(t => t.OrderLevel)
                    .ToList();
            
                dto.PgsSignatories = new List<PgsSignatoryDto>();

                if (templates.Any())
                {
                    var firstTemplate = templates.First();
                    var user = await _userManager.FindByIdAsync(firstTemplate.DefaultSignatoryId!);

                    dto.PgsSignatories.Add(new PgsSignatoryDto
                    {
                        Id = 0,
                        PgsId = pgs.Id,
                        PgsSignatoryTemplateId = firstTemplate.Id,
                        SignatoryId = firstTemplate.DefaultSignatoryId!,
                        Status = firstTemplate.Status,
                        Label = firstTemplate.SignatoryLabel,
                        OrderLevel = firstTemplate.OrderLevel,
                        IsNextStatus = true,
                        SignatoryName = $"{user?.Prefix} {user?.FirstName} {user?.LastName} {user?.Suffix}".Trim(),
                        DateSigned = default
                    });
                }

                return dto;
            }
          
            if (dto.PgsSignatories != null)
            {
                var currentStatus = pgs.PgsSignatories?.LastOrDefault();

                if (currentStatus != null)
                {
                    foreach (var signatory in dto.PgsSignatories)
                    {
                        var template = await _signatoryTemplateRepository
                            .GetByIdAsync(signatory.PgsSignatoryTemplateId, cancellationToken);
                        var user = await _userManager.FindByIdAsync(signatory.SignatoryId);

                        signatory.Label = template.SignatoryLabel;
                        signatory.Status = template.Status;
                        signatory.OrderLevel = template.OrderLevel;
                        signatory.SignatoryName = $"{user?.Prefix} {user?.FirstName} {user?.LastName} {user?.Suffix}".Trim();
                        signatory.IsNextStatus = false;
                    }

                    var templates = (await GetSignatoryTemplates(pgs.Office, cancellationToken))
                        .OrderBy(t => t.OrderLevel)
                        .ToList();

                    var currentTemplate = currentStatus.PgsSignatoryTemplate
                        ?? await _signatoryTemplateRepository.GetByIdAsync(currentStatus.PgsSignatoryTemplateId, cancellationToken);

                    var nextTemplate = templates.FirstOrDefault(t => t.OrderLevel == currentTemplate.OrderLevel + 1);

                    if (nextTemplate != null && nextTemplate.DefaultSignatoryId == userId)
                    {
                        // Proceed to next signatory
                        var user = await _userManager.FindByIdAsync(userId);
                        dto.PgsSignatories.Add(new PgsSignatoryDto
                        {
                            Id = 0,
                            PgsId = pgs.Id,
                            PgsSignatoryTemplateId = nextTemplate.Id,
                            SignatoryId = userId,
                            Status = nextTemplate.Status,
                            Label = nextTemplate.SignatoryLabel,
                            OrderLevel = nextTemplate.OrderLevel,
                            IsNextStatus = true,
                            SignatoryName = $"{user?.Prefix} {user?.FirstName} {user?.LastName} {user?.Suffix}".Trim()
                        });
                    }
                    else if (nextTemplate == null)
                    {
                      
                        var firstTemplate = templates.FirstOrDefault();
                        if (firstTemplate != null && firstTemplate.DefaultSignatoryId == userId)
                        {
                            var user = await _userManager.FindByIdAsync(userId);
                            dto.PgsSignatories.Add(new PgsSignatoryDto
                            {
                                Id = 0,
                                PgsId = pgs.Id,
                                PgsSignatoryTemplateId = firstTemplate.Id,
                                SignatoryId = userId,
                                Status = firstTemplate.Status,
                                Label = firstTemplate.SignatoryLabel,
                                OrderLevel = firstTemplate.OrderLevel,
                                IsNextStatus = true,
                                SignatoryName = $"{user?.Prefix} {user?.FirstName} {user?.LastName} {user?.Suffix}".Trim()
                            });
                        }
                    }
                }
            }


            return dto;
        }

        public async Task<List<PerfomanceGovernanceSystemDto>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            var records = await _repository.GetByUserIdAsync(userId, cancellationToken).ConfigureAwait(false);
            var result = new List<PerfomanceGovernanceSystemDto>();

            if (records == null || !records.Any())
                return result;

            foreach (var pgs in records)
            {
                cancellationToken.ThrowIfCancellationRequested();

                var dto = await ProcessPGSSignatories(pgs, userId, cancellationToken).ConfigureAwait(false);

                var deliverables = dto.PgsDeliverables ?? new List<PGSDeliverableDto>();
                bool hasDisapproved = deliverables.Any(d => d.IsDisapproved);

                var isFirstSignatory = dto.PgsSignatories?.Any(s =>
                    s.SignatoryId == userId && s.OrderLevel == 1
                ) ?? false;

                if (hasDisapproved && isFirstSignatory)
                {
                    
                    result.Add(dto);
                    continue;
                }

                var isNext = dto.PgsSignatories?.Any(s =>
                    s.SignatoryId == userId && s.IsNextStatus
                ) ?? false;

                if (isNext)
                {
                    result.Add(dto);
                }
            }

            return result;
        }

        private async Task<IEnumerable<PgsSignatoryTemplate>> GetSignatoryTemplates(Office office, CancellationToken cancellationToken)
        {
            // Try to get custom template or specific template of an office.
            // Basically if the office has it's own signatory workflow that differs on it's Service/Parent
            var signatoryTemplates = await _signatoryTemplateRepository
                .GetSignatoryTemplateByOfficeIdAsync(office.Id, cancellationToken)
                .ConfigureAwait(false);

            if (signatoryTemplates.Count == 0)
            {
                // Get the root parent office.
                var parentOffice = await _officeRepository
                    .GetRootParentOffice(office, cancellationToken)
                    .ConfigureAwait(false);

                // retrieve the template for services.
                signatoryTemplates = await _signatoryTemplateRepository
                    .GetSignatoryTemplateByOfficeIdAsync(parentOffice.Id, cancellationToken)
                    .ConfigureAwait(false);
            }

            return signatoryTemplates;
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
            return DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>.Create(perfomanceGovernanceSystemDto.Items, page, pageSize, perfomanceGovernanceSystemDto.TotalCount);
        }
        public async Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetPaginatedPgsPeriodIdAsync(long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var perfomanceGovernanceSystemDto = await _repository.GetPaginatedPgsPeriodIdAsync(pgsPeriodId, page, pageSize, cancellationToken).ConfigureAwait(false);
            return DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>.Create(perfomanceGovernanceSystemDto.Items, page, pageSize, perfomanceGovernanceSystemDto.TotalCount);
        }

        //public async Task<PerfomanceGovernanceSystemDto> SaveOrUpdateAsync(
        //PerfomanceGovernanceSystemDto perfomanceGovernanceSystemDto,
        //CancellationToken cancellationToken)
        //{
        //    if (perfomanceGovernanceSystemDto == null)
        //        throw new ArgumentNullException(nameof(perfomanceGovernanceSystemDto));

        //    var entity = perfomanceGovernanceSystemDto.ToEntity();


        //    entity.Office = await _officeRepository.GetByIdAsync(entity.Office.Id, cancellationToken);
        //    entity.PgsPeriod = await _pgsPeriodRepository.GetByIdAsync(entity.PgsPeriod.Id, cancellationToken);

        //    if (entity.PgsDeliverables != null)
        //    {
        //        foreach (var d in entity.PgsDeliverables)
        //        {
        //            d.Kra = await _kraRepository.GetByIdAsync(d.Kra!.Id, cancellationToken);
        //        }
        //    }

        //    var anyDisapproved = entity.PgsDeliverables?.Any(d => d.IsDisapproved) == true;

        //    if (anyDisapproved)
        //    {

        //        var existing = await _repository.GetByIdAsync(entity.Id, cancellationToken);

        //        if (existing?.PgsSignatories?.Any() == true)
        //        {
        //            _dbContext.PgsSignatory.RemoveRange(existing.PgsSignatories);
        //        }

        //        perfomanceGovernanceSystemDto.PgsSignatories = new List<PgsSignatoryDto>();
        //        entity.PgsSignatories = new List<PgsSignatory>();

        //        var templates = await _dbContext.PgsSignatoryTemplate
        //            .Where(t => t.OfficeId == entity.Office.OfficeTypeId)
        //            .OrderBy(t => t.OrderLevel)
        //            .ToListAsync(cancellationToken);

        //        var firstTemplate = templates.FirstOrDefault(t => t.OrderLevel == 1);

        //        if (firstTemplate != null)
        //        {                   
        //            var newSignatoryDto = new PgsSignatoryDto
        //            {
        //                Id = 0,
        //                PgsId = entity.Id,
        //                PgsSignatoryTemplateId = firstTemplate.Id,
        //                SignatoryId = firstTemplate.DefaultSignatoryId!,
        //                Status = firstTemplate.Status,
        //                Label = firstTemplate.SignatoryLabel,
        //                OrderLevel = firstTemplate.OrderLevel,
        //                IsNextStatus = true,
        //                DateSigned = default
        //            };

        //            perfomanceGovernanceSystemDto.PgsSignatories.Add(newSignatoryDto);
        //            entity.PgsSignatories.Add(newSignatoryDto.ToEntity());
        //        }
        //    }

        //    // Save changes
        //    var saved = await _repository.SaveOrUpdateAsync(entity, cancellationToken);

        //    return new PerfomanceGovernanceSystemDto(saved);
        //}


        public async Task<PerfomanceGovernanceSystemDto> SaveOrUpdateAsync(
        PerfomanceGovernanceSystemDto perfomanceGovernanceSystemDto,
        CancellationToken cancellationToken)
        {
            if (perfomanceGovernanceSystemDto == null)
                throw new ArgumentNullException(nameof(perfomanceGovernanceSystemDto));

            var entity = perfomanceGovernanceSystemDto.ToEntity();

            var office = await _officeRepository.GetByIdAsync(entity.Office.Id, cancellationToken)
                ?? throw new InvalidOperationException($"Office with ID {entity.Office.Id} not found.");

            var pgsPeriod = await _pgsPeriodRepository.GetByIdAsync(entity.PgsPeriod.Id, cancellationToken)
                ?? throw new InvalidOperationException($"PGS Period with ID {entity.PgsPeriod.Id} not found.");

            entity.Office = office;
            entity.OfficeId = office.Id;
            entity.PgsPeriod = pgsPeriod;

            // Resolve KRA
            if (entity.PgsDeliverables != null)
            {
                foreach (var d in entity.PgsDeliverables)
                {
                    d.Kra = await _kraRepository.GetByIdAsync(d.Kra!.Id, cancellationToken);
                    d.KraId = d.Kra.Id;
                }
            }

            var existing = await _dbContext.PerformanceGovernanceSystem
                .Include(p => p.PgsDeliverables)
                .Include(p => p.PgsSignatories)
                .Include(p => p.PgsReadinessRating)
                .FirstOrDefaultAsync(p => p.Id == entity.Id, cancellationToken)
                ?? throw new InvalidOperationException("PGS record not found.");

            var updatedIds = entity.PgsDeliverables?.Select(d => d.Id).ToList() ?? new();
            var toRemove = existing.PgsDeliverables!.Where(d => !updatedIds.Contains(d.Id)).ToList();

            if (toRemove.Any())
            {
                // Save to history
                var deliverableHistoryEntries = toRemove.Select(d => new PgsDeliverableHistory
                {
                    Id = 0,
                    PgsId = existing.Id,
                    DeliverableId = d.Id,
                    DeliverableTitle = d.DeliverableName,
                    Description = d.KraDescription,
                    KraId = d.KraId,
                    KraName = d.Kra?.Name,
                    RemovedBy = "System",
                    RemovedAt = DateTime.UtcNow
                }).ToList();

                _dbContext.PgsDeliverableHistory.AddRange(deliverableHistoryEntries);
                _dbContext.Deliverable.RemoveRange(toRemove);
            }

            var anyDisapproved = entity.PgsDeliverables?.Any(d => d.IsDisapproved) == true;
            if (anyDisapproved)
            {
                if (existing.PgsSignatories?.Any() == true)
                    _dbContext.PgsSignatory.RemoveRange(existing.PgsSignatories);

                perfomanceGovernanceSystemDto.PgsSignatories = new List<PgsSignatoryDto>();
                entity.PgsSignatories = new List<PgsSignatory>();

                var templates = await _dbContext.PgsSignatoryTemplate
                    .Where(t => t.OfficeId == office.OfficeTypeId)
                    .OrderBy(t => t.OrderLevel)
                    .ToListAsync(cancellationToken);

                var firstTemplate = templates.FirstOrDefault(t => t.OrderLevel == 1);
                if (firstTemplate != null)
                {
                    var newSignatoryDto = new PgsSignatoryDto
                    {
                        Id = 0,
                        PgsId = entity.Id,
                        PgsSignatoryTemplateId = firstTemplate.Id,
                        SignatoryId = firstTemplate.DefaultSignatoryId!,
                        Status = firstTemplate.Status,
                        Label = firstTemplate.SignatoryLabel,
                        OrderLevel = firstTemplate.OrderLevel,
                        IsNextStatus = true,
                        DateSigned = default
                    };

                    perfomanceGovernanceSystemDto.PgsSignatories.Add(newSignatoryDto);
                    entity.PgsSignatories.Add(newSignatoryDto.ToEntity());
                }
            }

            _dbContext.Entry(existing).CurrentValues.SetValues(entity);
            existing.OfficeId = office.Id;

            if (existing.PgsReadinessRating != null && entity.PgsReadinessRating != null)
            {
                existing.PgsReadinessRating.CompetenceToDeliver = entity.PgsReadinessRating.CompetenceToDeliver;
                existing.PgsReadinessRating.ConfidenceToDeliver = entity.PgsReadinessRating.ConfidenceToDeliver;
                existing.PgsReadinessRating.ResourceAvailability = entity.PgsReadinessRating.ResourceAvailability;
            }

            existing.PgsDeliverables!.Clear();
            foreach (var d in entity.PgsDeliverables ?? new List<PgsDeliverable>())
                existing.PgsDeliverables.Add(d);

            existing.PgsSignatories!.Clear();
            foreach (var s in entity.PgsSignatories ?? new List<PgsSignatory>())
                existing.PgsSignatories.Add(s);

            await _dbContext.SaveChangesAsync(cancellationToken);

            return new PerfomanceGovernanceSystemDto(existing);
        }

        // Save or Update Generic Method
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PerfomanceGovernanceSystemDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }

        public async Task<PerfomanceGovernanceSystemDto> Submit(PerfomanceGovernanceSystemDto pgs, string userId, CancellationToken cancellationToken)
        {
            var signatoryTemplates = await GetSignatoryTemplates(pgs.Office.ToEntity(), cancellationToken).ConfigureAwait(false);
            var initialStatus = signatoryTemplates.OrderBy(x => x.OrderLevel).FirstOrDefault();
            var initialSignatory = new PgsSignatoryDto()
            {
                Id = 0,
                PgsId = pgs.Id,
                PgsSignatoryTemplateId = initialStatus!.Id,
                SignatoryId = userId,
                DateSigned = DateTime.Now
            };

            pgs.PgsSignatories = pgs.PgsSignatories ?? [];
            pgs.PgsSignatories.Add(initialSignatory);

            return await SaveOrUpdateAsync(pgs, cancellationToken).ConfigureAwait(false);
        }



        public async Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetFilteredPGSAsync(PgsFilter filter, string userId, CancellationToken cancellationToken)
        {
            var pgs = await _repository.GetFilteredPGSAsync(filter, userId, cancellationToken).ConfigureAwait(false);
            var pagedPgs = DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>.Create(pgs.Items, filter.Page, filter.PageSize, pgs.TotalCount);
            foreach (var item in pagedPgs.Items)
            {
                var currentStatus = item.PgsSignatories?.LastOrDefault();
                if(currentStatus != null)
                {
                    foreach (var signatory in item.PgsSignatories!)
                    {
                        var signatoryTemplate = await _signatoryTemplateRepository
                            .GetByIdAsync(signatory.PgsSignatoryTemplateId, cancellationToken)
                            .ConfigureAwait(false);

                        var user = await _userManager
                            .FindByIdAsync(signatory.SignatoryId)
                            .ConfigureAwait(false);

                        signatory.Label = signatoryTemplate.SignatoryLabel;
                        signatory.Status = signatoryTemplate.Status;
                        signatory.OrderLevel = signatoryTemplate.OrderLevel;
                        signatory.SignatoryName = $"{user!.Prefix}. {user!.FirstName} {user!.LastName} {user!.Suffix}";
                        signatory.IsNextStatus = false;
                    }

                    var signatoryTemplates = await GetSignatoryTemplates(item.Office.ToEntity(), cancellationToken).ConfigureAwait(false);
                    var currentTemplate = await _signatoryTemplateRepository.GetByIdAsync(currentStatus.PgsSignatoryTemplateId, cancellationToken);

                    var nextTemplate = signatoryTemplates.Where(e => e.OrderLevel == (currentTemplate.OrderLevel + 1)).FirstOrDefault();

                    // Append signatory template, if the passed userId is equal to the DefaultSignatoryId
                    if (nextTemplate != null && nextTemplate.DefaultSignatoryId != null && nextTemplate.DefaultSignatoryId == userId)
                    {
                        var user = await _userManager
                            .FindByIdAsync(userId)
                            .ConfigureAwait(false);

                        item.PgsSignatories.Add(new PgsSignatoryDto()
                        {
                            Id = 0,
                            PgsId = item.Id,
                            PgsSignatoryTemplateId = nextTemplate.Id,
                            SignatoryId = userId,
                            Status = nextTemplate.Status,
                            Label = nextTemplate.SignatoryLabel,
                            OrderLevel = nextTemplate.OrderLevel,
                            IsNextStatus = true,
                            SignatoryName = $"{user!.Prefix}. {user!.FirstName} {user!.LastName} {user!.Suffix}"
                        });
                    }
                }
            }

            return pagedPgs;
        }

        public async Task Disapprove(long pgsId, CancellationToken cancellationToken)
        {
            await _repository.Disapprove(pgsId, cancellationToken).ConfigureAwait(false);
        }


    }
}
