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
             
        public async Task<PerfomanceGovernanceSystemDto?> GetByUserIdAndPgsIdAsync(string userId, int pgsId, CancellationToken cancellationToken)
        {
            var pgs = await _repository.GetByUserIdAndPgsIdAsync(userId, pgsId, cancellationToken);
            if (pgs == null) return null;

            var dto = await ProcessPGSSignatories(pgs, userId, cancellationToken);
            return dto;
        }

        private async Task<PerfomanceGovernanceSystemDto> ProcessPGSSignatories(PerfomanceGovernanceSystem pgs, string userId, CancellationToken cancellationToken)
        {
            var dto = new PerfomanceGovernanceSystemDto(pgs);

            if (dto.PgsSignatories != null)
            {
                var currentStatus = pgs.PgsSignatories?.LastOrDefault();
                if (currentStatus != null)
                {
                    foreach (var signatory in dto.PgsSignatories)
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

                    var signatoryTemplates = await GetSignatoryTemplates(pgs.Office, cancellationToken).ConfigureAwait(false);

                    var currentTemplate = currentStatus.PgsSignatoryTemplate
                        ?? await _signatoryTemplateRepository.GetByIdAsync(currentStatus.PgsSignatoryTemplateId, cancellationToken);

                    var nextTemplate = signatoryTemplates.Where(e => e.OrderLevel == (currentTemplate.OrderLevel + 1)).FirstOrDefault();

                    // Append signatory template, if the passed userId is equal to the DefaultSignatoryId
                    if (nextTemplate != null && nextTemplate.DefaultSignatoryId != null && nextTemplate.DefaultSignatoryId == userId)
                    {
                        var user = await _userManager
                            .FindByIdAsync(userId)
                            .ConfigureAwait(false);
                        dto.PgsSignatories.Add(new PgsSignatoryDto()
                        {
                            Id = 0,
                            PgsId = pgs.Id,
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

            return dto;
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
                var dto = await ProcessPGSSignatories(pgs, userId, cancellationToken).ConfigureAwait(false);
                result.Add(dto);
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

            return new PerfomanceGovernanceSystemDto(createdPerfomanceGovernanceSystem);
                
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
