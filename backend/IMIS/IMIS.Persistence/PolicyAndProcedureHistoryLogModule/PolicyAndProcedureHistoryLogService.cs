using Base.Primitives;
using IMIS.Application.PolicyAndProcedureHistoryLogModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PolicyAndProcedureHistoryLogModule
{
    public class PolicyAndProcedureHistoryLogService : IPolicyAndProcedureHistoryLogService
    {
        private readonly IPolicyAndProcedureHistoryLogRepository _repository;

        public PolicyAndProcedureHistoryLogService(IPolicyAndProcedureHistoryLogRepository repository)
        {
            _repository = repository;
        }

        public async Task<PolicyAndProcedureHistoryLogDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithListAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new PolicyAndProcedureHistoryLogDto(entity) : null;
        }

        public async Task<PolicyAndProcedureHistoryLogDto> SaveOrUpdateAsync(PolicyAndProcedureHistoryLogDto dto, CancellationToken cancellationToken)
        {
            var context = _repository.GetDbContext();
            PolicyAndProcedureHistoryLog entity;

            if (dto.Id == 0)
            {
                entity = dto.ToEntity();
                context.Set<PolicyAndProcedureHistoryLog>().Add(entity);
            }
            else
            {
                entity = await context.Set<PolicyAndProcedureHistoryLog>()
                    .Include(x => x.HistoryLogLists)
                    .FirstOrDefaultAsync(x => x.Id == dto.Id && !x.IsDeleted, cancellationToken)
                    ?? throw new InvalidOperationException("PolicyAndProcedureHistoryLog not found.");

                entity.PolicyAndProcedureId = dto.PolicyAndProcedureId;
                entity.Date = dto.Date;

                var incomingIds = dto.PolicyAndProcedureLogList
                    .Where(x => x.Id != 0)
                    .Select(x => x.Id)
                    .ToHashSet();

                foreach (var existingItem in entity.HistoryLogLists
                    .Where(x => !x.IsDeleted && !incomingIds.Contains(x.Id))
                    .ToList())
                {
                    existingItem.IsDeleted = true;
                }

                foreach (var item in dto.PolicyAndProcedureLogList)
                {
                    if (item.Id == 0)
                    {
                        var newItem = item.ToEntity();
                        newItem.PolicyAndProcedureHistoryLogId = entity.Id;
                        context.Set<PolicyAndProcedureHistoryLogList>().Add(newItem);
                        continue;
                    }

                    var match = entity.HistoryLogLists.FirstOrDefault(x => x.Id == item.Id && !x.IsDeleted);
                    if (match != null)
                    {
                        match.DocumentCode = item.DocumentCode;
                        match.PageNo = item.PageNo;
                        match.Revision = item.Revision;
                        match.Date = item.Date;
                        match.Reasons = item.Reasons;
                    }
                }
            }

            var affected = await context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            var saved = await _repository.GetByIdWithListAsync(entity.Id, cancellationToken).ConfigureAwait(false);
            return saved != null ? new PolicyAndProcedureHistoryLogDto(saved) : new PolicyAndProcedureHistoryLogDto(entity);
        }
       
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is PolicyAndProcedureHistoryLogDto historyLogDto)
            {
                await SaveOrUpdateAsync(historyLogDto, cancellationToken).ConfigureAwait(false);
                return;
            }

            throw new NotImplementedException($"SaveOrUpdateAsync is not implemented for DTO: {dto.GetType().Name}");
        }
    }
}