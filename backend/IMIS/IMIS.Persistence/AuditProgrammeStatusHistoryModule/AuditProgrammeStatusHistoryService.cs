using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditProgrammeStatusHistoryModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditProgrammeStatusHistoryModule
{
    public class AuditProgrammeStatusHistoryService : IAuditProgrammeStatusHistoryService
    {
        private readonly IAuditProgrammeStatusHistoryRepository _repository;

        public AuditProgrammeStatusHistoryService(IAuditProgrammeStatusHistoryRepository repository)
        {
            _repository = repository;
        }

        public async Task<List<AuditProgrammeStatusHistoryDto>> GetByProgrammeIdAsync(int auditProgrammeId, CancellationToken cancellationToken)
        {
            var histories = await _repository.GetByProgrammeIdAsync(auditProgrammeId, cancellationToken).ConfigureAwait(false);
            return histories.Select(x => new AuditProgrammeStatusHistoryDto(x)).ToList();
        }

        public async Task<DtoPageList<AuditProgrammeStatusHistoryDto, AuditProgrammeStatusHistory, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var paged = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<AuditProgrammeStatusHistoryDto, AuditProgrammeStatusHistory, int>.Create(
                paged.Items,
                page,
                pageSize,
                paged.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not AuditProgrammeStatusHistoryDto historyDto)
                throw new ArgumentException("Invalid DTO type. Expected AuditProgrammeStatusHistoryDto.");

            var entity = historyDto.ToEntity();

            if (entity.Id == 0)
            {
                _repository.Add(entity);
            }
            else
            {
                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }

        public async Task<(bool Success, string? Error)> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return (false, "Audit programme status history record not found.");

            entity.IsDeleted = true;
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return (true, null);
        }
    }
}