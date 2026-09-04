using Base.Auths;
using Base.Auths.Roles;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.SWOTAnalysisOTDeliverablesServiceHeadModule;
using IMIS.Application.SWOTAnalysisServiceHeadModule;
using IMIS.Application.SWOTAnalysisSWDeliverablesServiceHeadModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.SWOTAnalysisServiceHeadModule
{
    public class SWOTAnalysisServiceHeadService : ISWOTAnalysisServiceHeadService
    {
        private readonly ISWOTAnalysisServiceHeadRepository _repository;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
            
        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return currentUserService != null ? await currentUserService.GetCurrentUserAsync() : null;
        }      
        public SWOTAnalysisServiceHeadService(ISWOTAnalysisServiceHeadRepository repository, UserManager<User> userManager, RoleManager<IdentityRole> roleManager)
        {
            _repository = repository;
            _userManager = userManager;
            _roleManager = roleManager;
        }

        public async Task<DtoPageList<SWOTAnalysisServiceHeadDto, SWOTAnalysisServiceHead, long>?> GetPaginatedByUserIdAsync(string userId, string roleId, int? officeId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();

            if (currentUser == null)
                return null;

            var role = await _roleManager.FindByIdAsync(roleId);

            if (role == null)
                return null;

            EntityPageList<SWOTAnalysisServiceHead, long> pagedEntities;

            if (role.Name!.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase) ||
              role.Name.Equals(new PgsManagerRole().Name, StringComparison.OrdinalIgnoreCase) ||
              role.Name.Equals(new TWG().Name, StringComparison.OrdinalIgnoreCase) ||
              role.Name.Equals(new OSM().Name, StringComparison.OrdinalIgnoreCase) ||
              role.Name.Equals(new MCC().Name, StringComparison.OrdinalIgnoreCase) ||
              role.Name.Equals(new PgsAuditorHead().Name, StringComparison.OrdinalIgnoreCase) ||
              role.Name.Equals(new MSGC().Name, StringComparison.OrdinalIgnoreCase))
            {
                pagedEntities = await _repository.GetPaginatedAllAsync(officeId, page, pageSize, cancellationToken);
            }
            else if (role.Name.Equals(new PgsServiceHead().Name, StringComparison.OrdinalIgnoreCase))
            {
                pagedEntities = await _repository.GetPaginatedByUserIdAsync(userId, officeId, page, pageSize, cancellationToken);
            }
            else
            {
                return null;
            }

            if (pagedEntities.TotalCount == 0)
                 return null;

            return DtoPageList<SWOTAnalysisServiceHeadDto, SWOTAnalysisServiceHead, long>.Create(pagedEntities.Items, page, pageSize, pagedEntities.TotalCount);
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null)
                return false;

            entity.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        public async Task<SWOTAnalysisServiceHeadDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithChildrenAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new SWOTAnalysisServiceHeadDto(entity) : null;
        }

        private static SWOTAnalysisServiceHead BuildNewEntity(SWOTAnalysisServiceHeadDto dto) => new()
        {
            Id = 0,
            DepartmentId = dto.DepartmentId,
            ObjectiveStatement = dto.ObjectiveStatement,
            DepartmentChairUserId = dto.DepartmentChairUserId,        
            ServiceHeadUserId = dto.ServiceHeadUserId,
            PostingDate = dto.PostingDate,
            SWOTAnalysisSWDeliverablesServiceHead = dto.SWOTAnalysisSWDeliverablesServiceHead?.Select(BuildNewSWDeliverable).ToList() ?? new(),
            SWOTAnalysisOTDeliverablesServiceHead = dto.SWOTAnalysisOTDeliverablesServiceHead?.Select(BuildNewOTDeliverable).ToList() ?? new()
        };

        private static SWOTAnalysisSWDeliverablesServiceHead BuildNewSWDeliverable(SWOTAnalysisSWDeliverablesServiceHeadDto dto) => new()
        {
            Id = 0,
            InternalContextId = dto.InternalContextId,
            Strength = dto.Strength,
            Weaknesses = dto.Weaknesses
        };

        private static SWOTAnalysisOTDeliverablesServiceHead BuildNewOTDeliverable(SWOTAnalysisOTDeliverablesServiceHeadDto dto) => new()
        {
            Id = 0,
            ExternalContextId = dto.ExternalContextId,
            Opportunities = dto.Opportunities,
            Threats = dto.Threats
        };

        private void UpdateSWDeliverables(SWOTAnalysisServiceHead existing, List<SWOTAnalysisSWDeliverablesServiceHeadDto>? incoming)
        {
            existing.SWOTAnalysisSWDeliverablesServiceHead ??= new();
            var incomingIds = incoming?.Where(x => x.Id != 0).Select(x => x.Id).ToList() ?? new();

            foreach (var item in existing.SWOTAnalysisSWDeliverablesServiceHead.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
            {
                item.IsDeleted = true;
            }

            foreach (var itemDto in incoming ?? new())
            {
                if (itemDto.Id == 0)
                {
                    var newItem = BuildNewSWDeliverable(itemDto);
                    existing.SWOTAnalysisSWDeliverablesServiceHead.Add(newItem);
                    continue;
                }

                var match = existing.SWOTAnalysisSWDeliverablesServiceHead.FirstOrDefault(x => x.Id == itemDto.Id);
                if (match == null) continue;

                match.InternalContextId = itemDto.InternalContextId;
                match.Strength = itemDto.Strength;
                match.Weaknesses = itemDto.Weaknesses;
                match.IsDeleted = false;
            }
        }

        private void UpdateOTDeliverables(SWOTAnalysisServiceHead existing, List<SWOTAnalysisOTDeliverablesServiceHeadDto>? incoming)
        {
            existing.SWOTAnalysisOTDeliverablesServiceHead ??= new();
            var incomingIds = incoming?.Where(x => x.Id != 0).Select(x => x.Id).ToList() ?? new();

            foreach (var item in existing.SWOTAnalysisOTDeliverablesServiceHead.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
            {
                item.IsDeleted = true;
            }

            foreach (var itemDto in incoming ?? new())
            {
                if (itemDto.Id == 0)
                {
                    var newItem = BuildNewOTDeliverable(itemDto);
                    existing.SWOTAnalysisOTDeliverablesServiceHead.Add(newItem);
                    continue;
                }

                var match = existing.SWOTAnalysisOTDeliverablesServiceHead.FirstOrDefault(x => x.Id == itemDto.Id);
                if (match == null) continue;

                match.ExternalContextId = itemDto.ExternalContextId;
                match.Opportunities = itemDto.Opportunities;
                match.Threats = itemDto.Threats;
                match.IsDeleted = false;
            }
        }
        public async Task<SWOTAnalysisServiceHeadDto> SaveOrUpdateAsync(SWOTAnalysisServiceHeadDto dto, CancellationToken cancellationToken)
        {
            SWOTAnalysisServiceHead entity;

            if (dto.Id == 0)
            {
                entity = BuildNewEntity(dto);
                _repository.GetDbContext().Add(entity);
            }
            else
            {
                entity = await _repository.GetByIdWithChildrenAsync((int)dto.Id, cancellationToken) ?? throw new InvalidOperationException("Record not found.");

                entity.DepartmentId = dto.DepartmentId;
                entity.ObjectiveStatement = dto.ObjectiveStatement;
                entity.DepartmentChairUserId = dto.DepartmentChairUserId;             
                entity.ServiceHeadUserId = dto.ServiceHeadUserId;
                entity.PostingDate = dto.PostingDate;

                UpdateSWDeliverables(entity, dto.SWOTAnalysisSWDeliverablesServiceHead);
                UpdateOTDeliverables(entity, dto.SWOTAnalysisOTDeliverablesServiceHead);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken);

            return new SWOTAnalysisServiceHeadDto(entity);
        }

        public Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is SWOTAnalysisServiceHeadDto swotDto)
            {
                return SaveOrUpdateAsync(swotDto, cancellationToken);
            }

            throw new NotImplementedException($"SaveOrUpdateAsync is not implemented for DTO: {dto.GetType().Name}");
        }

    }
}
