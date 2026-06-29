using Base.Auths;
using Base.Auths.Roles;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.StrategyReviewModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.StrategyReviewModule
{
    public class StrategyReviewService : IStrategyReviewService
    {
        private readonly IStrategyReviewRepository _repository;
        private readonly IkraRoadMapRepository _kraRoadMapRepository;
        private readonly IKeyResultAreaRepository _kraRepository;
        private readonly IKraRoadMapKpiRepository _kraRoadMapKpiRepository;
        private readonly IKraRoadMapDeliverableRepository _kraRoadMapDeliverableRepository; 
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;

        public StrategyReviewService(IStrategyReviewRepository repository, IkraRoadMapRepository kraRoadMapRepository, IKeyResultAreaRepository kraRepository, IKraRoadMapKpiRepository kraRoadMapKpiRepository, IKraRoadMapDeliverableRepository kraRoadMapDeliverableRepository, UserManager<User> userManager, RoleManager<IdentityRole> roleManager)
        {
            _repository = repository;
            _kraRoadMapRepository = kraRoadMapRepository;
            _kraRepository = kraRepository;
            _kraRoadMapKpiRepository = kraRoadMapKpiRepository;
            _kraRoadMapDeliverableRepository = kraRoadMapDeliverableRepository;
            _userManager = userManager;
            _roleManager = roleManager;
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var SoftDelete = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (SoftDelete == null)
                return false;

            SoftDelete.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return await currentUserService!.GetCurrentUserAsync();
        }
     
        public async Task<DtoPageList<StrategyReviewDto, StrategyReview, long>> GetAllRoleIdAsync(string roleId, int? strategyReviewPeriodId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();

            if (currentUser == null)
            {
                return DtoPageList<StrategyReviewDto, StrategyReview, long>.Create(new List<StrategyReview>(), page, pageSize, 0);
            }

            var role = await _roleManager.FindByIdAsync(roleId);

            if (role == null)
            {
                return DtoPageList<StrategyReviewDto, StrategyReview, long>.Create(new List<StrategyReview>(),page,  pageSize, 0);
            }

            if (!await _userManager.IsInRoleAsync(currentUser, role.Name!))
            {
                return DtoPageList<StrategyReviewDto, StrategyReview, long>.Create(new List<StrategyReview>(), page, pageSize, 0);
            }

            List<StrategyReview> strategyReviews;

            if (
                role.Name!.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new StandardUserRole().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new MCC().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new PgsManagerRole().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new OSM().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new PgsServiceHead().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new PgsAuditorRole().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new TWG().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new MSGC().Name, StringComparison.OrdinalIgnoreCase)
            )
            {
                strategyReviews = await _repository.GetAll(cancellationToken) ?? new List<StrategyReview>();
            }
            else
            {
                strategyReviews = await _repository.GetAllForRoleAsync(role.Id, cancellationToken) ?? new List<StrategyReview>();
            }

            // FILTER BY PERIOD
            if (strategyReviewPeriodId.HasValue)
            {
                strategyReviews = strategyReviews.Where(x => x.StrategyReviewPeriodId == strategyReviewPeriodId.Value).ToList();
            }

            var totalCount = strategyReviews.Count; 

            var pagedItems = strategyReviews.Skip((page - 1) * pageSize).Take(pageSize).ToList();

            return DtoPageList<StrategyReviewDto, StrategyReview, long>.Create(pagedItems, page, pageSize, totalCount);
        }

        public async Task<StrategyReviewDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithChildrenAsync(id, cancellationToken).ConfigureAwait(false);

            if (entity == null)
                return null;

            string? strategicObjective = null;
            List<string> officeNames = new();

            // GET KRA ROADMAP
            var kraRoadMap = await _kraRoadMapRepository.GetByIdAsync(entity.KraRoadMapId, cancellationToken).ConfigureAwait(false);

            if (kraRoadMap == null)
                return new StrategyReviewDto(entity);

            // GET KRA
            if (kraRoadMap.KraId.HasValue)
            {
                var kra = await _kraRepository.GetByIdAsync(kraRoadMap.KraId.Value, cancellationToken).ConfigureAwait(false);
                strategicObjective = kra?.StrategicObjective;
            }

            // GET OFFICES
            officeNames = await _repository.GetOfficeNamesByKraRoadMapIdAsync(kraRoadMap.Id, cancellationToken).ConfigureAwait(false);

            // KPI IDS
            var kpiIds = entity.StrategyReviewDeliverableKpi?.Select(x => x.KraRoadmapid).Distinct().ToList() ?? new List<long>();

            // DELIVERABLE IDS
            var deliverableIds = entity.StrategyReviewDeliverable?.Select(x => x.KraRoadmapid).Distinct().ToList() ?? new List<long>();

            // GET KPI DATA
            var kpis = await _kraRoadMapKpiRepository.GetKpisByIdsAsync(kpiIds, cancellationToken).ConfigureAwait(false);

            // GET DELIVERABLE DATA
            var deliverables = await _kraRoadMapDeliverableRepository.GetDeliverablesByIdsAsync(deliverableIds, cancellationToken).ConfigureAwait(false);

            // MAP DTO
            var dto = new StrategyReviewDto(entity)
            {
                KraRoadMapId = entity.KraRoadMapId,
                StrategicObjective = strategicObjective,
                OfficeNames = string.Join(", ", officeNames)
            };

            // MAP KPI DETAILS
            if (dto.StrategyReviewDeliverableKpi != null)
            {
                foreach (var item in dto.StrategyReviewDeliverableKpi)
                {
                    var kpi = kpis.FirstOrDefault(x => x.Id == item.KpiId);

                    if (kpi != null)
                    {
                        item.KpiDetails = new KraRoadMapKpiDto(kpi);
                    }
                }
            }
            // MAP DELIVERABLE DETAILS
            if (dto.StrategyReviewDeliverable != null)
            {
                foreach (var item in dto.StrategyReviewDeliverable)
                {
                    var deliverable = deliverables.FirstOrDefault(x => x.Id == item.KraRoadmapid);

                    if (deliverable != null)
                    {
                        item.KraRoadMapDeliverableDetails = new KraRoadMapDeliverableDto(deliverable);
                    }
                }
            }
            return dto;
        }


        public async Task<ReportStrategyReviewDto?> ReportGetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithChildrenAsync(id, cancellationToken).ConfigureAwait(false);

            if (entity == null)
                return null;

            string? strategicObjective = null;
            List<string> officeNames = new();

            // GET KRA ROADMAP
            var kraRoadMap = await _kraRoadMapRepository.GetByIdAsync(entity.KraRoadMapId, cancellationToken).ConfigureAwait(false);

            if (kraRoadMap == null)
                return new ReportStrategyReviewDto(entity);

            // GET KRA
            if (kraRoadMap.KraId.HasValue)
            {
                var kra = await _kraRepository.GetByIdAsync(kraRoadMap.KraId.Value, cancellationToken).ConfigureAwait(false);
                strategicObjective = kra?.StrategicObjective;
            }

            // GET OFFICES
            officeNames = await _repository.GetOfficeNamesByKraRoadMapIdAsync(kraRoadMap.Id, cancellationToken).ConfigureAwait(false);

            // KPI IDS
            var kpiIds = entity.StrategyReviewDeliverableKpi?.Select(x => x.KraRoadmapid).Distinct().ToList() ?? new List<long>();

            // DELIVERABLE IDS
            var deliverableIds = entity.StrategyReviewDeliverable?.Select(x => x.KraRoadmapid).Distinct().ToList() ?? new List<long>();

            // GET KPI DATA
            var kpis = await _kraRoadMapKpiRepository.GetKpisByIdsAsync(kpiIds, cancellationToken).ConfigureAwait(false);

            // GET DELIVERABLE DATA
            var deliverables = await _kraRoadMapDeliverableRepository.GetDeliverablesByIdsAsync(deliverableIds, cancellationToken).ConfigureAwait(false);

            // MAP DTO
            var dto = new ReportStrategyReviewDto(entity)
            {
                KraRoadMapId = entity.KraRoadMapId,
                StrategicObjective = strategicObjective,
                OfficeNames = string.Join(", ", officeNames)
            };

            // MAP KPI DETAILS
            if (dto.StrategyReviewDeliverableKpi != null)
            {
                foreach (var item in dto.StrategyReviewDeliverableKpi)
                {
                    var kpi = kpis.FirstOrDefault(x => x.Id == item.KpiId);

                    if (kpi != null)
                    {
                        item.KpiDetails = new KraRoadMapKpiDto(kpi);
                    }
                }
            }
            // MAP DELIVERABLE DETAILS
            if (dto.StrategyReviewDeliverable != null)
            {
                foreach (var item in dto.StrategyReviewDeliverable)
                {
                    var deliverable = deliverables.FirstOrDefault(x => x.Id == item.KraRoadmapid);

                    if (deliverable != null)
                    {
                        item.KraRoadMapDeliverableDetails = new KraRoadMapDeliverableDto(deliverable);
                    }
                }
            }
            return dto;
        }


        public async Task<StrategyReviewDto> SaveOrUpdateAsync(StrategyReviewDto dto, CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();

            if (currentUser == null)
                throw new UnauthorizedAccessException("User not found.");

            var userRoleNames = await _userManager.GetRolesAsync(currentUser);

            bool isAdmin = userRoleNames.Any(r => r.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase));

            bool isNew = dto.Id == 0;

            StrategyReview entity;

            // CREATE
            if (isNew)
            {
                entity = dto.ToEntity();

                if (!isAdmin)
                {
                    if (string.IsNullOrEmpty(dto.RoleId))
                        throw new InvalidOperationException("RoleId is required.");

                    await ValidateUserRoleAsync(dto.RoleId, userRoleNames);
                    entity.RoleId = dto.RoleId;
                }

                _repository.GetDbContext().Add(entity);

                await _repository.SaveOrUpdateAsync(entity, cancellationToken);

                if (entity.StrategyReviewDeliverableKpi != null)
                {
                    foreach (var item in entity.StrategyReviewDeliverableKpi)
                    {
                        item.StrategyReviewId = entity.Id;
                    }
                }

                if (entity.StrategyReviewDeliverable != null)
                {
                    foreach (var item in entity.StrategyReviewDeliverable)
                    {
                        item.StrategyReviewId = entity.Id;
                    }
                }

                await _repository.SaveOrUpdateAsync(entity, cancellationToken);
            }

            // UPDATE
            else
            {
                entity = await _repository.GetDbContext()
                    .Set<StrategyReview>()
                    .Include(x => x.StrategyReviewDeliverableKpi)
                    .Include(x => x.StrategyReviewDeliverable)
                    .FirstOrDefaultAsync(x => x.Id == dto.Id, cancellationToken) ?? throw new InvalidOperationException("StrategyReview not found.");

                var originalRoleId = entity.RoleId;

                if (!isAdmin)
                {
                    if (string.IsNullOrEmpty(dto.RoleId))
                        throw new InvalidOperationException("RoleId is required.");

                    await ValidateUserRoleAsync(dto.RoleId, userRoleNames);
                }

                entity.PostingDate = dto.PostingDate;
                entity.StrategyReviewPeriodId = dto.StrategyReviewPeriodId;
                entity.KraRoadMapId = dto.KraRoadMapId;
                entity.Continue = dto.Continue;
                entity.Start = dto.Start;
                entity.Stop = dto.Stop;

                entity.RoleId = isAdmin ? originalRoleId : dto.RoleId;

                var updatedEntity = dto.ToEntity();

                UpdateStrategyReviewDeliverableKpi(entity, updatedEntity);

                UpdateStrategyReviewDeliverable(entity, updatedEntity);

                await _repository.SaveOrUpdateAsync(entity,  cancellationToken);
            }

            return new StrategyReviewDto(entity)
            {
                Id = entity.Id
            };
        }
        private async Task ValidateUserRoleAsync(string roleId, IList<string> userRoleNames)
        {
            var roleEntities = await _roleManager.Roles.Where(r => userRoleNames.Contains(r.Name!)).ToListAsync();

            if (!roleEntities.Any(r => r.Id == roleId))
            {
                throw new UnauthorizedAccessException(
                    "Invalid role assignment.");
            }
        }

        private void UpdateStrategyReviewDeliverableKpi(StrategyReview existing, StrategyReview incoming)
        {
            var incomingIds = incoming.StrategyReviewDeliverableKpi?.Select(x => x.Id).ToList() ?? new();

            // REMOVE DELETED =======
            foreach (var item in existing.StrategyReviewDeliverableKpi?.Where(x => !incomingIds.Contains(x.Id)).ToList() ?? new())
            {
                _repository.GetDbContext().Set<StrategyReviewDeliverableKpi>().Remove(item);
            }

            // ADD / UPDATE =======
            foreach (var item in incoming.StrategyReviewDeliverableKpi ?? new List<StrategyReviewDeliverableKpi>())
            {
                item.StrategyReviewId = existing.Id;

                // ADD ======
                if (item.Id == 0)
                {
                    existing.StrategyReviewDeliverableKpi ??= new();
                    existing.StrategyReviewDeliverableKpi.Add(item);
                    continue;
                }

                // UPDATE =======
                var match = existing.StrategyReviewDeliverableKpi?.FirstOrDefault(x => x.Id == item.Id);

                if (match != null)
                {
                    _repository.GetDbContext().Entry(match).CurrentValues.SetValues(item);
                    match.StrategyReviewId = existing.Id;
                }
            }
        }

        private void UpdateStrategyReviewDeliverable(StrategyReview existing, StrategyReview incoming)
        {
            var incomingIds = incoming.StrategyReviewDeliverable?.Select(x => x.Id).ToList() ?? new();

            // REMOVE DELETED ==========
            foreach (var item in existing.StrategyReviewDeliverable?.Where(x => !incomingIds.Contains(x.Id)).ToList() ?? new())
            {
                _repository.GetDbContext().Set<StrategyReviewDeliverable>().Remove(item);
            }

            // ADD / UPDATE ================
            foreach (var item in incoming.StrategyReviewDeliverable ?? new List<StrategyReviewDeliverable>())
            {
                item.StrategyReviewId = existing.Id;

                // ADD ==============
                if (item.Id == 0)
                {
                    existing.StrategyReviewDeliverable ??= new();
                    existing.StrategyReviewDeliverable.Add(item);
                    continue;
                }

                // UPDATE =============
                var match = existing.StrategyReviewDeliverable?.FirstOrDefault(x => x.Id == item.Id);

                if (match != null)
                {
                    _repository.GetDbContext().Entry(match).CurrentValues.SetValues(item);
                    match.StrategyReviewId = existing.Id;
                }
            }
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is StrategyReviewDto strategyReviewDto)
            {
                await SaveOrUpdateAsync(strategyReviewDto, cancellationToken);
                return;
            }

            throw new NotImplementedException($"SaveOrUpdateAsync is not implemented for DTO: {dto.GetType().Name}");
        }
    }
}
