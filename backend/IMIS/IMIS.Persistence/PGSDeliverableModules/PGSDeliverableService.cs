using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PGSModules
{
    public class PGSDeliverableService : IPGSDeliverableService
    {
        private readonly IPGSDeliverableRepository _repository;
        private readonly IKeyResultAreaRepository _kraRepository; 
        private readonly ImisDbContext _dbContext;
        private const string PgsDeliverableScoreHistoryTag = "PgsDeliverableScoreHistory";
       
        public PGSDeliverableService(IPGSDeliverableRepository repository, IKeyResultAreaRepository kraRepository, ImisDbContext dbContext)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _kraRepository = kraRepository ?? throw new ArgumentNullException(nameof(kraRepository));
            _dbContext = dbContext;           
        }      
        public async Task<DtoPageList<PGSDeliverableDto, PgsDeliverable, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsDeliverable = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            if(pgsDeliverable.TotalCount == 0)
            {
                return null;
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
                throw new InvalidOperationException("KRA not found");

            pgsDeliverableEntity.Kra = keyResultArea;
           
            if (pgsDeliverableEntity.Id == 0)
            {
                await _dbContext.Deliverable.AddAsync(pgsDeliverableEntity, cancellationToken);
            }
            else
            {
                var existingEntity = await _dbContext.Deliverable
                .Include(x => x.Kra) 
                .FirstOrDefaultAsync(x => x.Id == pgsDeliverableEntity.Id, cancellationToken);

                if (existingEntity == null)
                throw new InvalidOperationException("Deliverable not found for update");

                _dbContext.Entry(existingEntity).CurrentValues.SetValues(pgsDeliverableEntity);
            }

            await _dbContext.SaveChangesAsync(cancellationToken);
            return pgsDeliverableDto;
        }


        public async Task<List<PGSDeliverableDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pgsDeliverables = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return pgsDeliverables?.Select(o => ConvertToDto(o)).ToList();
        }
        public async Task<PGSDeliverableDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgsDeliverables = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pgsDeliverables != null ? ConvertToDto(pgsDeliverables) : null;
        }      
        private static PGSDeliverableDto ConvertToDto(PgsDeliverable deliverable)
        {
            return new PGSDeliverableDto
            {
                Id = deliverable.Id,                
                IsDirect = deliverable.IsDirect,
                DeliverableName = deliverable.DeliverableName,
                ByWhen = deliverable.ByWhen,
                PercentDeliverables = deliverable.PercentDeliverables,
                Status = deliverable.Status,
                RowVersion = deliverable.RowVersion ?? Array.Empty<byte>(),
                Remarks = deliverable.Remarks ?? string.Empty,
                KraDescription = deliverable.KraDescription ?? string.Empty,
                PerfomanceGovernanceSystemId = deliverable.PerfomanceGovernanceSystemId,
                Kra = deliverable.Kra != null ? new KeyResultAreaDto
                {
                    Id = deliverable.Kra.Id,
                    Name = deliverable.Kra.Name,
                    Remarks = deliverable.Kra.Remarks ?? string.Empty
                } : null
            };
        }      
        public async Task<PgsDeliverableMonitorPageList> GetFilteredAsync(PgsDeliverableMonitorFilter filter, CancellationToken cancellationToken)
        {
            var filteredDeliverables = await _repository.GetFilteredAsync(filter, cancellationToken).ConfigureAwait(false);
            return PgsDeliverableMonitorPageList.Create(filteredDeliverables.Items, filter.Page, filter.PageSize, filteredDeliverables.TotalCount);
        }

        public async Task<PgsDeliverableMonitorPageList> UpdateDeliverablesAsync(PgsDeliverableMonitorPageList request, IOutputCacheStore cache, CancellationToken cancellationToken)
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

                if (scoreChanged)
                {
                    var history = new PgsDeliverableScoreHistory
                    {
                        Id = 0,
                        PgsDeliverableId = deliverable.Id,
                        Date = DateTime.Now,
                        Score = dto.Score
                    };

                    _dbContext.Set<PgsDeliverableScoreHistory>().Add(history);
                    anyScoreChanged = true;
                }

                updatedItems.Add(dto);
            }

            await _dbContext.SaveChangesAsync(cancellationToken);

            // Evict the score history cache if any scores changed
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
