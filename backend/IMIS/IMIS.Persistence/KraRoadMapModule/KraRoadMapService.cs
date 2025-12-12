using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;
using IMIS.Persistence.AuditorModule;

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

        public async Task<KraRoadMapDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithChildrenAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new KraRoadMapDto(entity) : null;
        }

        public async Task<List<KraRoadMapDto>?> GetAll(CancellationToken cancellationToken)
        {
            var list = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return list?.Select(a => new KraRoadMapDto(a)).ToList();
        }
      
        public async Task<KraRoadMapDto> SaveOrUpdateAsync(KraRoadMapDto dto, CancellationToken cancellationToken)
        {
            var entity = dto.ToEntity();
        
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

