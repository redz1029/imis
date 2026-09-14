using Base.Pagination;
using Base.Primitives;
using IMIS.Application.StrategicChangeAgendaModule;
using IMIS.Domain;

namespace IMIS.Persistence.StrategicChangeAgendaModule
{
    public class StrategicChangeAgendaService : IStrategicChangeAgendaService
    {
        private readonly IStrategicChangeAgendaRepository _repository;

        public StrategicChangeAgendaService(IStrategicChangeAgendaRepository repository)
        {
            _repository = repository;
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
        public async Task<DtoPageList<StrategicChangeAgendaDto, StrategicChangeAgenda, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (entity.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<StrategicChangeAgendaDto, StrategicChangeAgenda, long>.Create(entity.Items, page, pageSize, entity.TotalCount);
        }

        public async Task<StrategicChangeAgendaDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithChildrenAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new StrategicChangeAgendaDto(entity) : null;
        }

        public async Task<StrategicChangeAgendaDto> SaveOrUpdateAsync(StrategicChangeAgendaDto dto,  CancellationToken cancellationToken)
        {
            bool isNew = dto.Id == 0;

            StrategicChangeAgenda entity;

            // CREATE
            if (isNew)
            {
                entity = dto.ToEntity();

                entity.StrategicChangeAgendaDeliverable =  FlattenDeliverableGroups(dto.StrategicChangeAgendaDeliverable);

                _repository.GetDbContext().Add(entity);

                await _repository.SaveOrUpdateAsync(entity, cancellationToken);
            }

            // UPDATE
            else
            {
                entity = await _repository.GetByIdWithChildrenAsync(dto.Id, cancellationToken) ?? throw new InvalidOperationException("Strategic Change Agenda record not found.");

                entity.From = dto.From;
                entity.To = dto.To;

                var updatedEntity = dto.ToEntity();

                UpdateDeliverables(entity, updatedEntity);

                await _repository.SaveOrUpdateAsync( entity,
                    cancellationToken);
            }

            return new StrategicChangeAgendaDto(entity)
            {
                Id = entity.Id
            };
        }
     
        private List<StrategicChangeAgendaDeliverable> FlattenDeliverableGroups(List<StrategicChangeAgendaDeliverableGroupDto>? groups)
        {
            if (groups == null)
                return new List<StrategicChangeAgendaDeliverable>();

            return groups
                .SelectMany(g =>  g.Items ??  new List<StrategicChangeAgendaDeliverable>())
                .ToList();
        }

        // UPDATE DELIVERABLES
        private void UpdateDeliverables(StrategicChangeAgenda existing,  StrategicChangeAgenda incoming)
        {
            var incomingIds = incoming.StrategicChangeAgendaDeliverable?
                    .Select(d => d.Id)
                    .ToList()
                ?? new List<long>();

            // SOFT DELETE REMOVED ITEMS
            foreach (
                var d in existing.StrategicChangeAgendaDeliverable!
                    .Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
                    {
                        d.IsDeleted = true;
                    }

            // ADD / UPDATE ITEMS
            foreach (var d in incoming.StrategicChangeAgendaDeliverable ?? new List<StrategicChangeAgendaDeliverable>())
            {
                if (d.Id == 0)
                {
                    // NEW ROW
                    d.IsDeleted = false;

                    existing.StrategicChangeAgendaDeliverable!.Add(d);

                    continue;
                }

                // Existing row
                var match = existing.StrategicChangeAgendaDeliverable!.FirstOrDefault(x => x.Id == d.Id);

                if (match != null)
                {
                    bool wasDeleted = match.IsDeleted;

                    _repository.GetDbContext()
                        .Entry(match)
                        .CurrentValues
                        .SetValues(d);

                    match.IsDeleted = wasDeleted;
                }
            }
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is StrategicChangeAgendaDto strategicChangeAgendaDto)
            {
                await SaveOrUpdateAsync(strategicChangeAgendaDto, cancellationToken);
                return;
            }

            throw new NotImplementedException($"SaveOrUpdateAsync is not implemented for DTO: {dto.GetType().Name}");
        }
    }
}