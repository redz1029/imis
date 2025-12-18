using Base.Pagination;
using Base.Primitives;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraRoadMapModule
{
    public class KraRoadMapService : IKraRoadMapService
    {
        private readonly IkraRoadMapRepository _repository;
        private readonly IKeyResultAreaRepository _kraRepository;
        private readonly IKraRoadMapPeriodRepository _kraRoadMapPeriodRepository;

        public KraRoadMapService(
            IkraRoadMapRepository repository,
            IKeyResultAreaRepository kraRepository,
            IKraRoadMapPeriodRepository kraRoadMapPeriodRepository)
        {
            _repository = repository;
            _kraRepository = kraRepository;
            _kraRoadMapPeriodRepository = kraRoadMapPeriodRepository;
        }
        public async Task<IEnumerable<KraRoadMapDescriptionFilter>> GetAllKraDescriptionsByKraIdAsync(int kraId, CancellationToken cancellationToken)
        {
            return await _repository.GetKraDescriptionsByKraIdAsync(kraId, cancellationToken);
        }
        public async Task<IEnumerable<KraRoadMapFilter>>GetFilteredDeliverablesAsync(int kraId, int year, string kraDescription, bool isDirect, CancellationToken cancellationToken)
        {
            return await _repository.GetByKraYearAndDescriptionAsync(kraId, year, kraDescription, isDirect, cancellationToken);
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var kraRoadMapDto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (kraRoadMapDto == null)
                return false;
            kraRoadMapDto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        public async Task<DtoPageList<KraRoadMapDto, KraRoadMap, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var kraRoadMapDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (kraRoadMapDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<KraRoadMapDto, KraRoadMap, long>.Create(kraRoadMapDto.Items, page, pageSize, kraRoadMapDto.TotalCount);
        }
        private KraRoadMapDto MapToDto(KraRoadMap entity)
        {
            if (entity == null) return null!; 

            var dto = new KraRoadMapDto(entity);

            dto.Deliverables = entity.Deliverables?
                .Where(d => !d.IsDeleted)
                .GroupBy(d => d.KraDescription)
                .Select(g => new KraRoadMapDeliverableGroupDto
                {
                    Id = 0,
                    KraDescription = g.Key,
                    Items = g.ToList()
                })
                .ToList();

            dto.Kpis = entity.Kpis?
                .Where(k => !k.IsDeleted)
                .Select(k => new KraRoadMapKpiDto
                {
                    Id = k.Id,
                    KpiDescription = k.KpiDescription,
                    IsDeleted = false,
                    RowVersion = k.RowVersion
                })
                .ToList();

            return dto;
        }
        public async Task<KraRoadMapDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithChildrenAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? MapToDto(entity) : null;
        }

        public async Task<List<KraRoadMapDto>?> GetAll(CancellationToken cancellationToken)
        {
            var list = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (list == null) return null;

            return list.Select(MapToDto).ToList();
        }

        private List<KraRoadMapDeliverable> FlattenDeliverableGroups(List<KraRoadMapDeliverableGroupDto>? groups)
        {
            if (groups == null) return new List<KraRoadMapDeliverable>();

            return groups.SelectMany(g => g.Items ?? new List<KraRoadMapDeliverable>()).ToList();
        }

        public async Task<KraRoadMapDto> SaveOrUpdateAsync(KraRoadMapDto dto, CancellationToken cancellationToken)
        {
            var flattenedDeliverables = FlattenDeliverableGroups(dto.Deliverables);

            var entity = dto.ToEntity();
            entity.Deliverables = flattenedDeliverables; 

            var kra = await _kraRepository.GetByIdAsync(entity.KraId!.Value, cancellationToken)
                      ?? throw new InvalidOperationException("Invalid KRA Id");

            var period = await _kraRoadMapPeriodRepository.GetByIdAsync(entity.KraRoadMapPeriodId, cancellationToken)
                         ?? throw new InvalidOperationException("Invalid RoadMap Period Id");

            entity.Kra = kra;
            entity.KraRoadMapPeriod = period;

            bool isNew = entity.Id == 0;

            if (isNew)
            {
                _repository.GetDbContext().Add(entity);
                await _repository.SaveOrUpdateAsync(entity, cancellationToken);
            }
            else
            {
                var existing = await _repository
                    .GetByIdWithChildrenAsync(entity.Id, cancellationToken)
                    ?? throw new InvalidOperationException("KraRoadMap record not found.");

                _repository.GetDbContext().Entry(existing).CurrentValues.SetValues(entity);
                existing.KraId = kra.Id;
                existing.KraRoadMapPeriodId = period.Id;

                UpdateDeliverables(existing, entity);
                UpdateKpis(existing, entity);

                await _repository.SaveOrUpdateAsync(existing, cancellationToken);

                entity = existing;
            }

            return new KraRoadMapDto(entity)
            {
                Id = entity.Id
            };
        }

        private void UpdateDeliverables(KraRoadMap existing, KraRoadMap incoming)
        {
            var incomingIds = incoming.Deliverables?.Select(d => d.Id).ToList() ?? new();

            foreach (var d in existing.Deliverables!.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
                d.IsDeleted = true;

            foreach (var d in incoming.Deliverables ?? new List<KraRoadMapDeliverable>())
            {
                if (d.Id == 0)
                {
                    existing.Deliverables!.Add(d);
                    continue;
                }

                var match = existing.Deliverables!.FirstOrDefault(x => x.Id == d.Id);
                if (match != null)
                {
                    bool wasDeleted = match.IsDeleted;
                    _repository.GetDbContext().Entry(match).CurrentValues.SetValues(d);
                    match.IsDeleted = wasDeleted;
                }
            }
        }

        private void UpdateKpis(KraRoadMap existing, KraRoadMap incoming)
        {
            var incomingIds = incoming.Kpis?.Select(k => k.Id).ToList() ?? new();

            foreach (var k in existing.Kpis!.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
                k.IsDeleted = true;

            foreach (var k in incoming.Kpis ?? new List<KraRoadMapKpi>())
            {
                if (k.Id == 0)
                {                                
                    existing.Kpis!.Add(k);
                    continue;
                }

                var match = existing.Kpis!.FirstOrDefault(x => x.Id == k.Id);
                if (match != null)
                {
                    bool wasDeleted = match.IsDeleted;
                    _repository.GetDbContext().Entry(match).CurrentValues.SetValues(k);
                    match.IsDeleted = wasDeleted;
                }
            }
        }
        
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is KraRoadMapDto km)
            {
                await SaveOrUpdateAsync(km, cancellationToken);
                return;
            }

            throw new NotImplementedException($"SaveOrUpdateAsync is not implemented for DTO: {dto.GetType().Name}");
        }
    }
}

