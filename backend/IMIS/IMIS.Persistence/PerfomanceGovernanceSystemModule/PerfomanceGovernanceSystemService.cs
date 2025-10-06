using Base.Auths;
using Base.Auths.Roles;
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
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using PgsStatus = IMIS.Application.PerfomanceGovernanceSystemModule.PgsStatus;

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
        public async Task<bool> SoftDeleteDeliverableAsync(int deliverableId, CancellationToken cancellationToken)
        {
            var context = _repository.GetDbContext();
            
            var deliverable = await context.Set<PerfomanceGovernanceSystem>()
                .FirstOrDefaultAsync(d => d.Id == deliverableId, cancellationToken);

            if (deliverable == null)
                return false;

            deliverable.IsDeleted = true;
            await context.SaveChangesAsync(cancellationToken);

            return true;
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
            var dto = new PerfomanceGovernanceSystemDto(pgs)
            {
                PgsDeliverables = pgs.PgsDeliverables?.Select(d => new PGSDeliverableDto(d)).ToList()
                                  ?? new List<PGSDeliverableDto>(),
                PgsSignatories = new List<PgsSignatoryDto>()
            };

            bool hasSavedSignatories = pgs.PgsSignatories != null && pgs.PgsSignatories.Any(s => s.Id > 0);

            dto.IsDraft = !hasSavedSignatories;

            if (dto.PgsDeliverables.Any(d => d.IsDisapproved))
            {
                if (pgs.PgsSignatories?.Any() == true)
                {
                    _repository.GetDbContext().RemoveRange(pgs.PgsSignatories);
                    await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
                }

                dto.PgsSignatories.Clear();

                var childOfficeHeadSig = pgs.Office.UserOffices?.FirstOrDefault(u => u.IsOfficeHead);
                if (childOfficeHeadSig != null)
                {
                    dto.PgsSignatories.Add(new PgsSignatoryDto
                    {
                        Id = 0,
                        PgsId = pgs.Id,
                        PgsSignatoryTemplateId = null,
                        SignatoryId = childOfficeHeadSig.UserId,
                        Label = PgsStatus.OfficeHead,
                        OrderLevel = 0,
                        Status = PgsStatus.Pending,
                        IsNextStatus = true
                    });
                }

                dto.IsDraft = true;
                return dto;
            }

            foreach (var s in pgs.PgsSignatories ?? Enumerable.Empty<PgsSignatory>())
            {
                int orderLevel = 0;
                string label = PgsStatus.OfficeHead;

                if (s.PgsSignatoryTemplateId != null)
                {
                    var template = await _signatoryTemplateRepository
                        .GetByIdAsync(s.PgsSignatoryTemplateId.Value, cancellationToken);
                    if (template != null)
                    {
                        orderLevel = template.OrderLevel;
                        label = template.SignatoryLabel;
                    }
                }

                dto.PgsSignatories.Add(new PgsSignatoryDto
                {
                    Id = s.Id,
                    PgsId = pgs.Id,
                    PgsSignatoryTemplateId = s.PgsSignatoryTemplateId,
                    SignatoryId = s.SignatoryId,
                    Label = label,
                    OrderLevel = orderLevel,
                    Status = s.DateSigned != default ? PgsStatus.Prepared : PgsStatus.Pending,
                    IsNextStatus = false,
                    DateSigned = s.DateSigned
                });
            }

            var childOfficeHead = pgs.Office.UserOffices?.FirstOrDefault(u => u.IsOfficeHead);
            var officeTemplates = await _signatoryTemplateRepository
                .GetSignatoryTemplateByOfficeIdAsync(pgs.Office.Id, cancellationToken);

            if (!hasSavedSignatories && (officeTemplates == null || !officeTemplates.Any()) && childOfficeHead != null)
            {
                dto.PgsSignatories.Add(new PgsSignatoryDto
                {
                    Id = 0,
                    PgsId = pgs.Id,
                    PgsSignatoryTemplateId = null,
                    SignatoryId = childOfficeHead.UserId,
                    Label = PgsStatus.OfficeHead,
                    OrderLevel = 0,
                    Status = PgsStatus.Pending,
                    IsNextStatus = false
                });
            }

            var templates = await GetInheritedSignatoryTemplatesAsync(pgs.Office, cancellationToken);
            foreach (var t in templates.OrderBy(t => t.OrderLevel))
            {
                bool alreadyExists = dto.PgsSignatories.Any(s =>
                    s.PgsSignatoryTemplateId == t.Id ||
                    s.SignatoryId == t.DefaultSignatoryId);

                if (alreadyExists) continue;

                dto.PgsSignatories.Add(new PgsSignatoryDto
                {
                    Id = 0,
                    PgsId = pgs.Id,
                    PgsSignatoryTemplateId = t.Id > 0 ? t.Id : null,
                    SignatoryId = t.DefaultSignatoryId!,
                    Label = t.SignatoryLabel,
                    OrderLevel = t.OrderLevel,
                    Status = PgsStatus.Pending,
                    IsNextStatus = false
                });
            }

            var nextPending = dto.PgsSignatories
                .Where(s => s.Status!.Equals(PgsStatus.Pending, StringComparison.OrdinalIgnoreCase))
                .OrderBy(s => s.OrderLevel)
                .FirstOrDefault();

            if (nextPending != null)
                nextPending.IsNextStatus = true;

            dto.PgsSignatories = dto.PgsSignatories
                .Where(s => s.Status!.Equals(PgsStatus.Prepared, StringComparison.OrdinalIgnoreCase) || s.IsNextStatus)
                .OrderBy(s => s.OrderLevel)
                .ToList();

            return dto;
        }


        private async Task<IEnumerable<PgsSignatoryTemplate>> GetInheritedSignatoryTemplatesAsync(Office office, CancellationToken cancellationToken)
        {
            if (office == null) return Enumerable.Empty<PgsSignatoryTemplate>();

            var templates = await _signatoryTemplateRepository.GetSignatoryTemplateByOfficeIdAsync(office.Id, cancellationToken);
            if (templates != null && templates.Any())
            {
                return templates.OrderBy(t => t.OrderLevel);
            }

            var parentOffice = office.ParentOffice ?? await _officeRepository.GetRootParentOffice(office, cancellationToken);
            if (parentOffice == null) return Enumerable.Empty<PgsSignatoryTemplate>();

            var parentTemplates = await GetInheritedSignatoryTemplatesAsync(parentOffice, cancellationToken);

            var childHead = office.UserOffices?.FirstOrDefault(u => u.IsOfficeHead);
            var clonedTemplates = parentTemplates.Select(t => new PgsSignatoryTemplate
            {
                Id = t.Id,
                SignatoryLabel = t.SignatoryLabel,
                DefaultSignatoryId = t.DefaultSignatoryId,
                OrderLevel = t.OrderLevel,
                OfficeId = t.OfficeId,
                IsActive = t.IsActive,
                IsDeleted = t.IsDeleted,
                RowVersion = t.RowVersion,
                Status = t.Status                
               
            }).ToList();

            return clonedTemplates.OrderBy(t => t.OrderLevel);
        }
            
        public async Task<List<PerfomanceGovernanceSystemDto>?> GetByUserIdAsync(
        string userId,
        CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();
            if (currentUser == null)
                return new List<PerfomanceGovernanceSystemDto>();

            var userRoles = await _userManager.GetRolesAsync(currentUser);

            if (userRoles.Any(r => 
                r.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase) ||
                r.Equals(new PgsManagerRole().Name, StringComparison.OrdinalIgnoreCase)))
            {
                
                var allRecords = await _repository.GetAll(cancellationToken).ConfigureAwait(false);

                var tempList = new List<PerfomanceGovernanceSystemDto>();

                foreach (var pgs in allRecords)
                {
                    cancellationToken.ThrowIfCancellationRequested();

                    var dto = await ProcessPGSSignatories(pgs, userId, cancellationToken).ConfigureAwait(false);
                   
                    dto.PgsDeliverables = dto.PgsDeliverables?
                        .Where(d => !d.IsDeleted)
                        .ToList() ?? new List<PGSDeliverableDto>();

                    tempList.Add(dto);
                }

                var result = tempList
                    .OrderByDescending(dto => dto.PgsSignatories!.Any(s => s.SignatoryId == userId && s.IsNextStatus))
                    .ThenBy(dto => dto.PgsPeriod?.StartDate)
                    .ToList();

                return result;

            }

            var records = await _repository.GetByUserIdAsync(userId, cancellationToken).ConfigureAwait(false);

            var filtered = new List<PerfomanceGovernanceSystemDto>();
            if (records == null || !records.Any())
                return filtered;

            foreach (var pgs in records)
            {
                cancellationToken.ThrowIfCancellationRequested();

                var dto = await ProcessPGSSignatories(pgs, userId, cancellationToken).ConfigureAwait(false);

                dto.PgsDeliverables = dto.PgsDeliverables?
                    .Where(d => !d.IsDeleted)
                    .ToList() ?? new List<PGSDeliverableDto>();

                var isUserAssignedToOffice = pgs.Office.UserOffices?.Any(u => u.UserId == userId) ?? false;
                
                var isDraft = dto.PgsSignatories == null || !dto.PgsSignatories.Any(s => s.Id > 0);
                dto.IsDraft = isDraft;
                if (isDraft)
                {
                    var templates = (await GetInheritedSignatoryTemplatesAsync(pgs.Office, cancellationToken))
                        .OrderBy(t => t.OrderLevel)
                        .ToList();

                    var firstTemplate = templates.FirstOrDefault();
                    var officeHead = pgs.Office.UserOffices?.FirstOrDefault(u => u.IsOfficeHead);

                    var canDraftView = (firstTemplate?.DefaultSignatoryId == userId) || (officeHead?.UserId == userId);

                    if (isUserAssignedToOffice || canDraftView)
                        filtered.Add(dto);

                    continue;
                }

                var isNext = dto.PgsSignatories?.Any(s => s.SignatoryId == userId && s.IsNextStatus) ?? false;
                var isSubmittedBy = dto.PgsSignatories?.Any(s =>
                    s.SignatoryId == userId &&
                    s.Status!.Equals(PgsStatus.Prepared, StringComparison.OrdinalIgnoreCase)) ?? false;

                var lastSubmitted = dto.PgsSignatories!
                    .Where(s => s.Status!.Equals(PgsStatus.Prepared, StringComparison.OrdinalIgnoreCase))
                    .OrderByDescending(s => s.OrderLevel)
                    .FirstOrDefault();

                bool canViewAsParent = false;

                if (lastSubmitted != null)
                {
                    var nextSignatory = dto.PgsSignatories!
                        .Where(s => s.OrderLevel > lastSubmitted.OrderLevel)
                        .OrderBy(s => s.OrderLevel)
                        .FirstOrDefault();

                    if (nextSignatory != null && nextSignatory.IsNextStatus)
                    {
                        var parentUser = pgs.Office.ParentOffice?.UserOffices?.Any(u => u.UserId == userId) ?? false;

                        if (parentUser && nextSignatory.SignatoryId == userId)
                        {
                            canViewAsParent = true;
                        }
                    }
                }

                if (isUserAssignedToOffice)
                {
                    filtered.Add(dto);
                }
                else if (isNext || canViewAsParent)
                {
                    filtered.Add(dto);
                }
            }

            return filtered;
        }

        private async Task<IEnumerable<PgsSignatoryTemplate>> GetSignatoryTemplates(Office office, CancellationToken cancellationToken)
        {
            // Try to get custom template or specific template of an office.
            // Basically if the office has it's own signatory workflow that differs on it's Service/Parent
            var templates = await _signatoryTemplateRepository
                .GetSignatoryTemplateByOfficeIdAsync(office.Id, cancellationToken)
                .ConfigureAwait(false);

            if (!templates.Any())
            {
                return Enumerable.Empty<PgsSignatoryTemplate>();
            }

            var result = templates.Select(t => new PgsSignatoryTemplate
            {
                Id = t.Id,
                Status = t.Status,
                SignatoryLabel = t.Status.Equals(PgsStatus.Prepared, StringComparison.OrdinalIgnoreCase) ? PgsStatus.PreparedBy : t.SignatoryLabel,
                OrderLevel = t.OrderLevel,
                DefaultSignatoryId = t.DefaultSignatoryId,
                IsActive = t.IsActive,
                IsDeleted = t.IsDeleted
            });

            return result.OrderBy(t => t.OrderLevel);
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

        public async Task<PerfomanceGovernanceSystemDto> SaveOrUpdateAsync(PerfomanceGovernanceSystemDto pgsDto, CancellationToken cancellationToken)
        {
            if (pgsDto == null)
                throw new ArgumentNullException(nameof(pgsDto));

            var entity = pgsDto.ToEntity();

            var office = await _officeRepository.GetByIdAsync(entity.Office.Id, cancellationToken)
                ?? throw new InvalidOperationException($"Office with ID {entity.Office.Id} not found.");

            var pgsPeriod = await _pgsPeriodRepository.GetByIdAsync(entity.PgsPeriod.Id, cancellationToken)
                ?? throw new InvalidOperationException($"PGS Period with ID {entity.PgsPeriod.Id} not found.");

            entity.Office = office;
            entity.OfficeId = office.Id;
            entity.PgsPeriod = pgsPeriod;

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
                    if (d.Id == 0)
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

                    var currentUserorderLevel = await GetCurrentUserAsync();
                    var isChildOfficeHead = await _userOfficeRepository.IsUserOfficeHeadAsync(currentUserorderLevel!.Id, office.Id, cancellationToken);


                    if (isChildOfficeHead)
                    {

                        foreach (var s in entity.PgsSignatories ?? new List<PgsSignatory>())
                        {
                            s.PgsSignatoryTemplateId = null;
                            s.DateSigned = DateTime.UtcNow;

                            if (existing?.PgsSignatories?.Any(es => es.SignatoryId == s.SignatoryId) != true)
                            {
                                existing?.PgsSignatories?.Add(s);
                            }
                        }
                    }

                    else
                    {

                        foreach (var s in entity.PgsSignatories ?? new List<PgsSignatory>())
                        {
                            var existingSignatory = existing?.PgsSignatories?
                                .FirstOrDefault(es => es.Id == s.Id);

                            if (existingSignatory != null)
                            {
                                existingSignatory.IsDeleted = false;
                                _repository.GetDbContext().Entry(existingSignatory).CurrentValues.SetValues(s);
                            }
                            else
                            {
                                existing?.PgsSignatories?.Add(s);
                            }
                        }
                    }
                }

                _repository.GetDbContext().Entry(existing).CurrentValues.SetValues(entity);
                existing.OfficeId = office.Id;

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


        // Save or Update
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

                var processedPgsDto = await ProcessPGSSignatories(existing, userId, cancellationToken);
                pgs.PgsSignatories = processedPgsDto.PgsSignatories;

                var currentSignatory = pgs.PgsSignatories!.FirstOrDefault(s => s.IsNextStatus);
                if (currentSignatory != null)
                {
                    currentSignatory.SignatoryId = userId;
                    currentSignatory.DateSigned = DateTime.UtcNow;
                    currentSignatory.Status = PgsStatus.Prepared;
                    currentSignatory.IsNextStatus = true;

                    var nextSignatory = processedPgsDto.PgsSignatories!
                        .Where(s => s.Status == PgsStatus.Pending && s.Id == 0)
                        .OrderBy(s => s.OrderLevel)
                        .FirstOrDefault();

                    if (nextSignatory != null)
                    {
                        nextSignatory.IsNextStatus = true;

                        pgs.PgsSignatories = new List<PgsSignatoryDto> { currentSignatory, nextSignatory };
                    }
                    else
                    {
                        pgs.PgsSignatories = new List<PgsSignatoryDto> { currentSignatory };
                    }
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
                            .GetByIdAsync(signatory.PgsSignatoryTemplateId ?? 0, cancellationToken)
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
                    var currentTemplate = await _signatoryTemplateRepository.GetByIdAsync(currentStatus.PgsSignatoryTemplateId ?? 0, cancellationToken);

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
