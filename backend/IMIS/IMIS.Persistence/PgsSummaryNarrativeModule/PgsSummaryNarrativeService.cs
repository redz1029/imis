using Base.Auths;
using Base.Auths.Roles;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsSummaryNarrativeModule;
using IMIS.Application.PgsSummaryNarrativeModules;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;
using Sprache;


namespace IMIS.Persistence.PgsSummaryNarrativeModule
{
    public class PgsSummaryNarrativeService : IPGSSummaryNarrativeService
    {
        private readonly IPGSSummaryNarrativeRepository _repository;
        private readonly IOfficeRepository _officeRepository;
        private readonly IKeyResultAreaRepository _keyResulktAreaRepository;
        private readonly UserManager<User> _userManager;

        public PgsSummaryNarrativeService(IPGSSummaryNarrativeRepository repository, IOfficeRepository officeRepository, IKeyResultAreaRepository keyResulktAreaRepository, UserManager<User> userManager)
        {
            _repository = repository;
            _officeRepository = officeRepository;
            _keyResulktAreaRepository = keyResulktAreaRepository;
            _userManager = userManager;
        }
        public async Task<PGSSummaryNarrativeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var narrative = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return narrative != null ? new PGSSummaryNarrativeDto(narrative) : null;
        }       
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var narrative = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (narrative == null)
                return false;

            narrative.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return await currentUserService!.GetCurrentUserAsync();
        }

        // Auditor Role       
        public async Task<IEnumerable<PGSSummaryNarrativeDto>> GetNarrativesForAuditorAsync(
        int? periodId,
        int? office,
        CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();
            if (currentUser == null)
                return Enumerable.Empty<PGSSummaryNarrativeDto>();

            var userRoles = await _userManager.GetRolesAsync(currentUser);
            IEnumerable<PgsSummaryNarrative> entities;

            if (userRoles.Any(r =>
                    r.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase) ||
                    r.Equals(new PgsAuditorHead().Name, StringComparison.OrdinalIgnoreCase) ||
                    r.Equals(new MCC().Name, StringComparison.OrdinalIgnoreCase)))
            {
                
                entities = await _repository.GetAllFilteredNarrativeForHeadsAsync(periodId, office, cancellationToken);
            }
            else if (userRoles.Any(r => r.Equals(new PgsAuditorRole().Name, StringComparison.OrdinalIgnoreCase)))
            {
               
                entities = await _repository.GetNarrativesByAuditorAsync(currentUser.Id, periodId, office, cancellationToken);
            }
            else
            {
                return Enumerable.Empty<PGSSummaryNarrativeDto>();
            }
         
            return entities.Select(n => new PGSSummaryNarrativeDto
            {
                Id = n.Id,
                Findings = n.Findings,
                Recommendation = n.Recommendation,
                Conclusion = n.Conclusion,
                PgsPeriodId = n.PgsPeriodId,
                OfficeId = n.OfficeId
            });
        }

        // Head Auditor Role
        public async Task<IEnumerable<PGSSummaryNarrativeDto>> GetNarrativesForHeadAuditorAsync(int? periodId, int? office, CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();
            if (currentUser == null)
                return Enumerable.Empty<PGSSummaryNarrativeDto>();

            var userRoles = await _userManager.GetRolesAsync(currentUser);

            if (!userRoles.Any(r => r.Equals(new PgsAuditorHead().Name, StringComparison.OrdinalIgnoreCase) || 
                                    r.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase) ||
                                    r.Equals(new MCC().Name, StringComparison.OrdinalIgnoreCase)))
                return Enumerable.Empty<PGSSummaryNarrativeDto>();

            var entities = await _repository.GetAllForAuditorHeadAsync(periodId, office, cancellationToken);

            return entities.Select(n => new PGSSummaryNarrativeDto
            {
                Id = n.Id,
                Findings = n.Findings,
                Recommendation = n.Recommendation,
                Conclusion = n.Conclusion,
                PgsPeriodId = n.PgsPeriodId,
                OfficeId = n.OfficeId
            });
        }
        
        public async Task<List<ReportPGSSummaryNarrativeDto>> ReportGetByFilterAsync(PgsDeliverableSummaryNarrativeFilter filter, CancellationToken cancellationToken)
        {
            var narratives = await _repository.GetNarrativesByFilterAsync(filter, cancellationToken);
            var periodIds = narratives
                .Where(n => n.PgsPeriodId.HasValue)
                .Select(n => n.PgsPeriodId!.Value)
                .ToList();

            var deliverables = await _repository.GetFilteredDeliverablesAsync(periodIds, filter, cancellationToken);
           
            OfficeDto? officeDto = null;
            if (!string.IsNullOrEmpty(filter.OfficeId))
            {
                var office = await _officeRepository.GetByIdAsync(int.Parse(filter.OfficeId), cancellationToken);
                if (office != null)
                    officeDto = new OfficeDto(office);
            }
            KeyResultAreaDto? keyResultAreaDto = null;
            if (!string.IsNullOrEmpty(filter.Kra))
            {
                var kra = await _keyResulktAreaRepository.GetByIdAsync(int.Parse(filter.Kra), cancellationToken);
                if (kra != null)
                    keyResultAreaDto = new KeyResultAreaDto(kra);
            }
            var reportDtos = narratives.Select(n =>
            {
                return new ReportPGSSummaryNarrativeDto(
                    n,
                    deliverables,
                    filter,
                    officeDto,
                    keyResultAreaDto
                );
            }).ToList();

            return reportDtos;
        }

        public async Task<PGSSummaryNarrativeDto?> GetByPeriodIdAsync(int pgsPeriodId, CancellationToken cancellationToken)
        {
            var narrative = await _repository.GetByPeriodIdAsync(pgsPeriodId, cancellationToken).ConfigureAwait(false);
            return narrative == null ? null : new PGSSummaryNarrativeDto(narrative);
        }
    
        public async Task<List<PGSSummaryNarrativeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pgsNarrativeSummary = await _repository.GetAll(cancellationToken).ConfigureAwait(false);

            if (pgsNarrativeSummary == null)
                return null;

            return pgsNarrativeSummary
                .Select(x => new PGSSummaryNarrativeDto(x))
                .ToList();
        }

        public async Task<DtoPageList<PGSSummaryNarrativeDto, PgsSummaryNarrative, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsSignatoryTemplateDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (pgsSignatoryTemplateDto.TotalCount == 0)
                return null;
            return DtoPageList<PGSSummaryNarrativeDto, PgsSummaryNarrative, int>.Create(pgsSignatoryTemplateDto.Items, page, pageSize, pgsSignatoryTemplateDto.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as PGSSummaryNarrativeDto;
            if (ODto == null) throw new ArgumentException("Invalid DTO type.");

          
            var pgsSummaryNarrativeDto = ODto!.ToEntity();

            if (pgsSummaryNarrativeDto.Id == 0)
                _repository.Add(pgsSummaryNarrativeDto);
            else
                await _repository.UpdateAsync(pgsSummaryNarrativeDto, pgsSummaryNarrativeDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(pgsSummaryNarrativeDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
