using Base.Auths;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PgsSignatoryModule;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Application.UserOfficeModule;
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
        private readonly IUserOfficeRepository _userOfficeRepository;


        public PerfomanceGovernanceSystemService(IPerfomanceGovernanceSystemRepository repository, IOfficeRepository officeRepository, IPgsPeriodRepository pgsPeriodRepository, IKeyResultAreaRepository kraRepository, UserManager<User> userManager, IPgsSignatoryTemplateRepository signatoryTemplateRepository, IUserOfficeRepository userOfficeRepository)
        {
            _repository = repository;
            _officeRepository = officeRepository;
            _pgsPeriodRepository = pgsPeriodRepository;
            _kraRepository = kraRepository;
            _userManager = userManager;
            _signatoryTemplateRepository = signatoryTemplateRepository;
            _userOfficeRepository = userOfficeRepository;
           
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
                    _repository.GetDbContext().RemoveRange(pgs.PgsSignatories);
                    await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
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

                var isUserAssignedToOffice = pgs.Office.UserOffices!
                    .Any(u => u.UserId == userId);

                // Save as Draft kung walang signatories
                var isDraft = pgs.PgsSignatories == null || !pgs.PgsSignatories.Any();

                if (isDraft)
                {
                    var templates = await GetSignatoryTemplates(pgs.Office, cancellationToken);

                    var isUserSignatoryDraft = templates.Any(t => t.DefaultSignatoryId == userId);
                    var isFirstSignatory = templates
                        .OrderBy(t => t.OrderLevel)
                        .FirstOrDefault()?.DefaultSignatoryId == userId;

                    if ((isUserAssignedToOffice && !isUserSignatoryDraft) || isFirstSignatory)
                    {
                        var draftDto = new PerfomanceGovernanceSystemDto(pgs);
                        draftDto.PgsDeliverables = draftDto.PgsDeliverables?
                            .Where(d => !d.IsDeleted)
                            .ToList() ?? new List<PGSDeliverableDto>();

                        result.Add(draftDto);
                    }

                    continue;
                }

                // Submitted/with signatories
                var dto = await ProcessPGSSignatories(pgs, userId, cancellationToken)
                    .ConfigureAwait(false);

                dto.PgsDeliverables = dto.PgsDeliverables?
                    .Where(d => !d.IsDeleted)
                    .ToList() ?? new List<PGSDeliverableDto>();

                // Get signatory template to determine actual signatory roless
                var signatoryTemplates = await GetSignatoryTemplates(pgs.Office, cancellationToken);
                var isUserSignatoryTemplate = signatoryTemplates.Any(t => t.DefaultSignatoryId == userId);

                var isFirstSignatorySubmitted = dto.PgsSignatories?.Any(s =>
                    s.SignatoryId == userId && s.OrderLevel == 1
                ) ?? false;

                var isNext = dto.PgsSignatories?.Any(s =>
                    s.SignatoryId == userId && s.IsNextStatus
                ) ?? false;

                // Only show if:
                // - User is the first signatory
                // - User is the next signatory
                // - OR user belongs to office but is not part of signatory template
                bool canViewSubmitted = isFirstSignatorySubmitted || isNext || (isUserAssignedToOffice && !isUserSignatoryTemplate);

                if (canViewSubmitted)
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
                //Get the root parent office.
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

        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return await currentUserService!.GetCurrentUserAsync();
        }

        public async Task<PerfomanceGovernanceSystemDto> SaveOrUpdateAsync(
        PerfomanceGovernanceSystemDto pgsDto,
        CancellationToken cancellationToken)
        {
            if (pgsDto == null)
                throw new ArgumentNullException(nameof(pgsDto));

            var entity = pgsDto.ToEntity();

            // Load required references
            var office = await _officeRepository.GetByIdAsync(entity.Office.Id, cancellationToken)
                ?? throw new InvalidOperationException($"Office with ID {entity.Office.Id} not found.");

            var pgsPeriod = await _pgsPeriodRepository.GetByIdAsync(entity.PgsPeriod.Id, cancellationToken)
                ?? throw new InvalidOperationException($"PGS Period with ID {entity.PgsPeriod.Id} not found.");

            entity.Office = office;
            entity.OfficeId = office.Id;
            entity.PgsPeriod = pgsPeriod;

            // Attach deliverables            
            if (entity.PgsDeliverables != null)
            {
                foreach (var d in entity.PgsDeliverables)
                {
                    d.Kra = null;

                    if (d.KraId > 0)
                    {
                        d.KraId = d.KraId;
                    }
                }
            }

            var isDraft = entity.PgsSignatories == null || !entity.PgsSignatories.Any();
            var isNew = entity.Id == 0;

            if (isNew)
            {
                // Add new deliverables
                foreach (var d in entity.PgsDeliverables ?? Enumerable.Empty<PgsDeliverable>())
                    _repository.GetDbContext().Entry(d).State = EntityState.Added;

                // Add new signatories kapag hindi draft
                if (!isDraft)
                {
                    foreach (var s in entity.PgsSignatories ?? Enumerable.Empty<PgsSignatory>())
                        _repository.GetDbContext().Entry(s).State = EntityState.Added;
                }

                _repository.GetDbContext().Add(entity);
            }
            else
            {
                var existing = await _repository.GetWithIncludesAsync((int)entity.Id, cancellationToken)
                    ?? throw new InvalidOperationException("PGS record not found.");

                //--- Deliverable Updates ---
                var updatedIds = entity.PgsDeliverables?.Select(d => d.Id).ToList() ?? new();
                var removedDeliverables = existing.PgsDeliverables!
                    .Where(d => !updatedIds.Contains(d.Id) && !d.IsDeleted)
                    .ToList();

                var currentUser = await GetCurrentUserAsync();
                var removedByName = currentUser?.Id ?? "UnknownUserId";

                foreach (var d in removedDeliverables)
                {
                    d.IsDeleted = true;
                    d.RemovedBy = removedByName;
                    d.RemovedAt = DateTime.UtcNow;
                    _repository.GetDbContext().Entry(d).State = EntityState.Modified;
                }


                var existingDeliverables = existing.PgsDeliverables?.ToList() ?? new List<PgsDeliverable>();
                foreach (var d in entity.PgsDeliverables ?? new List<PgsDeliverable>())
                {
                    if (d.Id == 0) // New deliverable
                    {
                        existing.PgsDeliverables!.Add(d);
                    }
                    else
                    {
                        var existingDeliverable = existingDeliverables.FirstOrDefault(ed => ed.Id == d.Id);
                        if (existingDeliverable != null)
                        {
                            var tempIsDeleted = existingDeliverable.IsDeleted;                          

                            // Update values
                            _repository.GetDbContext().Entry(existingDeliverable).CurrentValues.SetValues(d);

                            existingDeliverable.IsDeleted = tempIsDeleted;                          
                        }
                        else
                        {
                            existing.PgsDeliverables!.Add(d);
                        }
                    }
                }


                if (isDraft)
                {

                    if (existing.PgsSignatories?.Any() == true)
                    {
                        foreach (var s in existing.PgsSignatories)
                        {
                            s.IsDeleted = true;
                        }
                    }

                    entity.PgsSignatories = new List<PgsSignatory>();
                }
                else
                {
                    // Submit: add or reactivate signatories
                    foreach (var s in entity.PgsSignatories ?? new List<PgsSignatory>())
                    {
                        var existingSignatory = existing.PgsSignatories?
                            .FirstOrDefault(es => es.Id == s.Id);

                        if (existingSignatory != null)
                        {
                            // Reactivate if previously soft-removed
                            existingSignatory.IsDeleted = false;
                            _repository.GetDbContext().Entry(existingSignatory).CurrentValues.SetValues(s);
                        }
                        else
                        {
                            existing.PgsSignatories?.Add(s);
                        }
                    }
                }

                _repository.GetDbContext().Entry(existing).CurrentValues.SetValues(entity);
                existing.OfficeId = office.Id;

                // Update readiness rating if present
                if (existing.PgsReadinessRating != null && entity.PgsReadinessRating != null)
                {
                    existing.PgsReadinessRating.CompetenceToDeliver = entity.PgsReadinessRating.CompetenceToDeliver;
                    existing.PgsReadinessRating.ConfidenceToDeliver = entity.PgsReadinessRating.ConfidenceToDeliver;
                    existing.PgsReadinessRating.ResourceAvailability = entity.PgsReadinessRating.ResourceAvailability;
                }
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return new PerfomanceGovernanceSystemDto(entity);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PerfomanceGovernanceSystemDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }

        public async Task<PerfomanceGovernanceSystemDto> Submit(PerfomanceGovernanceSystemDto pgs, string userId, CancellationToken cancellationToken)
        {

            if (pgs == null)
                throw new ArgumentNullException(nameof(pgs));

            // Load ang existing PGS record 
            var existing = await _repository.GetWithIncludesAsync((int)pgs.Id, cancellationToken)
                ?? throw new InvalidOperationException("PGS record not found.");

            // Mag update muna ng Existing Deliverables
            foreach (var d in pgs.PgsDeliverables ?? new List<PGSDeliverableDto>())
            {
                var existingDeliverable = existing.PgsDeliverables?.FirstOrDefault(ed => ed.Id == d.Id);
                if (existingDeliverable != null)
                {
                    // Update fieldsW
                    _repository.GetDbContext().Entry(existingDeliverable).CurrentValues.SetValues(d);
                    existingDeliverable.IsDeleted = existingDeliverable.IsDeleted;
                }
                else
                {
                    // Add new deliverable
                    existing.PgsDeliverables ??= new List<PgsDeliverable>();
                }
            }

            // Check kung may deliverable na disapproved
            var anyDisapproved = existing.PgsDeliverables?.Any(d => d.IsDisapproved && !d.IsDeleted) == true;

            if (anyDisapproved)
            {
                // Remove existing signatories
                if (existing.PgsSignatories?.Any() == true)
                {
                    _repository.GetDbContext().RemoveRange(existing.PgsSignatories);
                    existing.PgsSignatories.Clear();
                }

                pgs.PgsSignatories = new List<PgsSignatoryDto>();
            }
            else
            {
                // Handle initial signatory if none exists
                pgs.PgsSignatories ??= new List<PgsSignatoryDto>();

                var signatoryTemplates = await GetSignatoryTemplates(pgs.Office.ToEntity(), cancellationToken);
                var initialTemplate = signatoryTemplates.OrderBy(t => t.OrderLevel).FirstOrDefault();

                if (initialTemplate != null &&
                    !existing.PgsSignatories!.Any(s => s.PgsSignatoryTemplateId == initialTemplate.Id))
                {
                    var initialSignatory = new PgsSignatoryDto
                    {
                        Id = 0,
                        PgsId = pgs.Id,
                        PgsSignatoryTemplateId = initialTemplate.Id,
                        SignatoryId = userId,
                        DateSigned = DateTime.Now
                    };
                    pgs.PgsSignatories.Add(initialSignatory);
                }
            }

            return await SaveOrUpdateAsync(pgs, cancellationToken);
        }

        public async Task<PerfomanceGovernanceSystemDto> Draft(PerfomanceGovernanceSystemDto pgs, string userId, CancellationToken cancellationToken)
        {

            pgs.PgsSignatories = new List<PgsSignatoryDto>();
            return await SaveOrUpdateAsync(pgs, cancellationToken).ConfigureAwait(false);
        }


        public async Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetFilteredPGSAsync(PgsFilter filter, string userId, CancellationToken cancellationToken)
        {
            var pgs = await _repository.GetFilteredPGSAsync(filter, userId, cancellationToken).ConfigureAwait(false);
            var pagedPgs = DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>.Create(pgs.Items, filter.Page, filter.PageSize, pgs.TotalCount);
            foreach (var item in pagedPgs.Items)
            {
                var currentStatus = item.PgsSignatories?.LastOrDefault();
                if (currentStatus != null)
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

    }
}
