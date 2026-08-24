
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.SWOTAnalysisModule;
using IMIS.Application.SWOTAnalysisSWDeliverablesModule;
using IMIS.Application.SWOTAnalysisOTDeliverablesModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Base.Auths;
using Base.Auths.Roles;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.SWOTAnalysisModule
{
    public class SWOTAnalysisService : ISWOTAnalysisService
    {
        private readonly ISWOTAnalysisRepository _repository;
        private readonly UserManager<User> _userManager;

        private static readonly string[] ElevatedRoleNames =
        {
            new AdministratorRole().Name,
            new PgsServiceHead().Name,
            new PgsManagerRole().Name,
            new MCC().Name,
            new OSM().Name,
            new MSGC().Name,
            new TWG().Name
        };

        public SWOTAnalysisService(ISWOTAnalysisRepository repository, UserManager<User> userManager)
        {
            _repository = repository;
            _userManager = userManager;
        }


        public async Task<List<SWOTAnalysisDto>?> FilterByYearAsync(int year, int noOfResults, CancellationToken cancellationToken)
        {
            if (year <= 0) year = DateTime.Now.Year;

            var currentUser = await GetCurrentUserAsync();
            if (currentUser == null)
                return null;

            bool isElevatedUser = await IsElevatedUserAsync(currentUser);

            return isElevatedUser
                ? await _repository.FilterByYearAsync(year, noOfResults, cancellationToken)
                : await _repository.FilterByYearByUserAsync(currentUser.Id, year, noOfResults, cancellationToken);
        }

        public async Task<DtoPageList<SWOTAnalysisDto, SWOTAnalysis, long>?> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (pagedEntities.TotalCount == 0)
                return null;

            return DtoPageList<SWOTAnalysisDto, SWOTAnalysis, long>.Create(pagedEntities.Items, page, pageSize, pagedEntities.TotalCount);
        }

        public async Task<SWOTAnalysisDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithChildrenAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new SWOTAnalysisDto(entity) : null;
        }
        public async Task<ReportSWOTAnalysisDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithChildrenAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new ReportSWOTAnalysisDto(entity) : null;
        }

        public async Task<List<SWOTAnalysisDto>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();
            if (currentUser == null)
                return null;

            bool isElevatedUser = await IsElevatedUserAsync(currentUser);

            var swotEntities = isElevatedUser
                ? await _repository.GetAllAsync(cancellationToken)
                : await _repository.GetByUserIdAsync(currentUser.Id, cancellationToken) ?? new List<SWOTAnalysis>();

            return swotEntities.Select(e => new SWOTAnalysisDto(e)).ToList();
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

        private static SWOTAnalysis BuildNewEntity(SWOTAnalysisDto dto) => new()
        {
            Id = 0,
            DepartmentId = dto.DepartmentId,
            ObjectiveStatement = dto.ObjectiveStatement,
            DepartmentChairUserId = dto.DepartmentChairUserId,
            QMRUserId = dto.QMRUserId,
            ServiceHeadUserId = dto.ServiceHeadUserId,
            PostingDate = dto.PostingDate,
            SWOTAnalysisSWDeliverables = dto.SWOTAnalysisSWDeliverables?.Select(BuildNewSWDeliverable).ToList() ?? new(),
            SWOTAnalysisOTDeliverables = dto.SWOTAnalysisOTDeliverables?.Select(BuildNewOTDeliverable).ToList() ?? new()
        };

        private static SWOTAnalysisSWDeliverables BuildNewSWDeliverable(SWOTAnalysisSWDeliverablesDto dto) => new()
        {
            Id = 0,
            InternalContextId = dto.InternalContextId,
            Opportunities = dto.Opportunities,
            Threats = dto.Threats
        };

        private static SWOTAnalysisOTDeliverables BuildNewOTDeliverable(SWOTAnalysisOTDeliverablesDto dto) => new()
        {
            Id = 0,
            ExternalContextId = dto.ExternalContextId,
            Opportunities = dto.Opportunities,
            Threats = dto.Threats
        };

        private void UpdateSWDeliverables(SWOTAnalysis existing, List<SWOTAnalysisSWDeliverablesDto>? incoming)
        {
            existing.SWOTAnalysisSWDeliverables ??= new();
            var incomingIds = incoming?.Where(x => x.Id != 0).Select(x => x.Id).ToList() ?? new();

            foreach (var item in existing.SWOTAnalysisSWDeliverables.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
            {
                item.IsDeleted = true;
            }

            foreach (var itemDto in incoming ?? new())
            {
                if (itemDto.Id == 0)
                {
                    var newItem = BuildNewSWDeliverable(itemDto);
                    newItem.SWOTAnalysisId = (int?)existing.Id;
                    existing.SWOTAnalysisSWDeliverables.Add(newItem);
                    continue;
                }

                var match = existing.SWOTAnalysisSWDeliverables.FirstOrDefault(x => x.Id == itemDto.Id);
                if (match == null) continue;

                match.InternalContextId = itemDto.InternalContextId;
                match.Opportunities = itemDto.Opportunities;
                match.Threats = itemDto.Threats;
                match.IsDeleted = false;
            }
        }

        private void UpdateOTDeliverables(SWOTAnalysis existing, List<SWOTAnalysisOTDeliverablesDto>? incoming)
        {
            existing.SWOTAnalysisOTDeliverables ??= new();
            var incomingIds = incoming?.Where(x => x.Id != 0).Select(x => x.Id).ToList() ?? new();

            foreach (var item in existing.SWOTAnalysisOTDeliverables.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
            {
                item.IsDeleted = true;
            }

            foreach (var itemDto in incoming ?? new())
            {
                if (itemDto.Id == 0)
                {
                    var newItem = BuildNewOTDeliverable(itemDto);
                    newItem.SWOTAnalysisId = (int?)existing.Id;
                    existing.SWOTAnalysisOTDeliverables.Add(newItem);
                    continue;
                }

                var match = existing.SWOTAnalysisOTDeliverables.FirstOrDefault(x => x.Id == itemDto.Id);
                if (match == null) continue;

                match.ExternalContextId = itemDto.ExternalContextId;
                match.Opportunities = itemDto.Opportunities;
                match.Threats = itemDto.Threats;
                match.IsDeleted = false;
            }
        }
        public async Task<SWOTAnalysisDto> SaveOrUpdateAsync(SWOTAnalysisDto dto, CancellationToken cancellationToken)
        {
            SWOTAnalysis entity;

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
                entity.QMRUserId = dto.QMRUserId;
                entity.ServiceHeadUserId = dto.ServiceHeadUserId;
                entity.PostingDate = dto.PostingDate;

                UpdateSWDeliverables(entity, dto.SWOTAnalysisSWDeliverables);
                UpdateOTDeliverables(entity, dto.SWOTAnalysisOTDeliverables);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken);

            return new SWOTAnalysisDto(entity);
        }

        public Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is SWOTAnalysisDto swotDto)
            {
                return SaveOrUpdateAsync(swotDto, cancellationToken);
            }

            throw new NotImplementedException($"SaveOrUpdateAsync is not implemented for DTO: {dto.GetType().Name}");
        }

        private async Task<bool> IsElevatedUserAsync(User user)
        {
            var userRoles = await _userManager.GetRolesAsync(user);
            return userRoles.Any(r => ElevatedRoleNames.Any(er => er.Equals(r, StringComparison.OrdinalIgnoreCase)));
        }

        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return currentUserService != null
                ? await currentUserService.GetCurrentUserAsync()
                : null;
        }
    }
}