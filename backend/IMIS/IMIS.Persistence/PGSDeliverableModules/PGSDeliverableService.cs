using Base.Auths;
using Base.Auths.Roles;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.OutputCaching;

namespace IMIS.Persistence.PGSModules
{
    public class PGSDeliverableService : IPGSDeliverableService
    {
        private readonly IPGSDeliverableRepository _repository;
        private readonly IKeyResultAreaRepository _kraRepository;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;

        private const string PgsDeliverableScoreHistoryTag = "PgsDeliverableScoreHistory";
       
        public PGSDeliverableService(IPGSDeliverableRepository repository, IKeyResultAreaRepository kraRepository, UserManager<User> userManager, RoleManager<IdentityRole> roleManager)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _kraRepository = kraRepository ?? throw new ArgumentNullException(nameof(kraRepository));
            _userManager = userManager;
            _roleManager = roleManager;

        }       
        public async Task<DtoPageList<PGSDeliverableDto, PgsDeliverable, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsDeliverable = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            if(pgsDeliverable.TotalCount == 0)
            {
                return null!;
            }
            return DtoPageList<PGSDeliverableDto, PgsDeliverable, long>.Create(pgsDeliverable.Items, page, pageSize, pgsDeliverable.TotalCount);
        }
        public async Task<PGSDeliverableDto> SaveOrUpdateAsync(PGSDeliverableDto pgsDeliverableDto, CancellationToken cancellationToken)
        {
            if (pgsDeliverableDto == null)
                throw new ArgumentNullException(nameof(pgsDeliverableDto));

            var pgsDeliverableEntity = pgsDeliverableDto.ToEntity();

            if (pgsDeliverableEntity.Kra == null || pgsDeliverableEntity.Kra.Id == 0)
                throw new InvalidOperationException("Invalid KRA ID");

            var keyResultArea = await _kraRepository.GetByIdAsync(pgsDeliverableEntity.Kra.Id, cancellationToken);
            if (keyResultArea == null)
                throw new InvalidOperationException("KRA ID not found");

            pgsDeliverableEntity.KraId = keyResultArea.Id;
            pgsDeliverableEntity.Kra = null; 
            pgsDeliverableEntity.IsDeleted = false;
                      
            if (pgsDeliverableEntity.Id == 0)
            {
                await _repository.GetDbContext().AddAsync(pgsDeliverableEntity, cancellationToken);
            }
            else
            {
                await _repository.UpdateAsync(pgsDeliverableEntity, pgsDeliverableEntity.Id, cancellationToken);
            }

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);

            return new PGSDeliverableDto(pgsDeliverableEntity);
        }        
        public async Task<List<PGSDeliverableDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pgsDeliverables = await _repository.GetAll(cancellationToken).ConfigureAwait(false);

            if (pgsDeliverables == null)
                return null;

            return pgsDeliverables.Select(d => new PGSDeliverableDto(d)).ToList();
        }
        public async Task<PGSDeliverableDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgsDeliverable = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pgsDeliverable != null ? new PGSDeliverableDto(pgsDeliverable) : null;
        }        
        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return await currentUserService!.GetCurrentUserAsync();
        }
       

        public async Task<PgsDeliverableMonitorPageList> GetFilteredAsync(PgsDeliverableMonitorFilter filter, CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();

            if (currentUser == null)
                return PgsDeliverableMonitorPageList.Create([], filter.Page, filter.PageSize, 0);

            if (string.IsNullOrWhiteSpace(filter.RoleId))
                return PgsDeliverableMonitorPageList.Create([], filter.Page, filter.PageSize, 0);

            var role = await _roleManager.FindByIdAsync(filter.RoleId);

            if (role == null)
                return PgsDeliverableMonitorPageList.Create([], filter.Page, filter.PageSize, 0);

            if (!filter.PgsPeriodId.HasValue)
            {
                var currentPeriodId = await _repository.GetCurrentYearPeriodIdAsync(DateTime.Now.Year,cancellationToken);

                if (currentPeriodId == null)
                    return PgsDeliverableMonitorPageList.Create([], filter.Page, filter.PageSize, 0);

                filter.PgsPeriodId = (int?)currentPeriodId;
            }

            bool hasFullAccess =
                role.Name!.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new PgsServiceHead().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new PgsAuditorHead().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new PgsManagerRole().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new PgsHead().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new MCC().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new OSM().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new TWG().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new MSGC().Name, StringComparison.OrdinalIgnoreCase);

            List<int>? officeIds = null;

            if (!hasFullAccess)
            {
                officeIds = await _repository.GetUserOfficeIdsAsync(currentUser.Id, cancellationToken);

                if (!officeIds.Any())
                    return PgsDeliverableMonitorPageList.Create([], filter.Page, filter.PageSize, 0);
            }

            var filtered = await _repository.GetFilteredAsync(filter, officeIds, cancellationToken);

            return PgsDeliverableMonitorPageList.Create(filtered.Items, filter.Page, filter.PageSize, filtered.TotalCount);
        }

        public async Task<PgsDeliverableMonitorPageList> UpdateDeliverablesAsync(
         PgsDeliverableMonitorPageList request,
         IOutputCacheStore cache,
         CancellationToken cancellationToken)
         {
            var updatedItems = new List<PgsDeliverableMonitorDto>();
            bool anyScoreChanged = false;

            foreach (var dto in request.Items)
            {
                var deliverable = await _repository.GetByIdAsync(dto.PgsDeliverableId, cancellationToken);
                if (deliverable == null)
                    continue;

                bool scoreChanged = deliverable.PercentDeliverables != dto.Score;

                deliverable.Remarks = dto.Remarks;
                deliverable.PercentDeliverables = dto.Score;
                deliverable.Status = Enum.TryParse<PgsStatus>(dto.Status, out var status)
                    ? status
                    : deliverable.Status;
                    
                await _repository.UpdateAsync(deliverable, deliverable.Id, cancellationToken);

                updatedItems.Add(dto);
            }            
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
           
            if (anyScoreChanged)
            {
                await cache.EvictByTagAsync(PgsDeliverableScoreHistoryTag, cancellationToken);
            }

            return new PgsDeliverableMonitorPageList(
                updatedItems,
                request.Page,
                request.PageSize,
                updatedItems.Count
            );
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
          where TEntity : Entity<TId>
        {

            var ODto = dto as PGSDeliverableDto;
            var pgsDeliverableDto = ODto!.ToEntity();

            if (pgsDeliverableDto.Id == 0)
                _repository.Add(pgsDeliverableDto);
            else
                await _repository.UpdateAsync(pgsDeliverableDto, pgsDeliverableDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(pgsDeliverableDto, cancellationToken).ConfigureAwait(false);
        }       
    }
}
