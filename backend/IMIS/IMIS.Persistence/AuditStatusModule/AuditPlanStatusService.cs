using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditStatusModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditStatusModule
{
    public class AuditPlanStatusService : IAuditPlanStatusService
    {
        private readonly IAuditPlanStatusRepository _repository;

        public AuditPlanStatusService(IAuditPlanStatusRepository repository)
        {
            _repository = repository;
        }

        public async Task<List<AuditPlanStatusDto>> GetAllAsync(CancellationToken cancellationToken)
        {
            var auditStatuses = await _repository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            return auditStatuses.Select(x => new AuditPlanStatusDto(x)).ToList();
        }

        public async Task<DtoPageList<AuditPlanStatusDto, AuditPlanStatus, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var paged = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<AuditPlanStatusDto, AuditPlanStatus, int>.Create(
                paged.Items,
                page,
                pageSize,
                paged.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not AuditPlanStatusDto auditStatusDto)
                throw new ArgumentException("Invalid DTO type. Expected AuditStatusDto.");

            var entity = auditStatusDto.ToEntity();

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
            if (entity == null) return (false, "Status not found.");

            var inUse = await _repository.IsInUseAsync(id, cancellationToken).ConfigureAwait(false);
            if (inUse) return (false, "Cannot delete a status that is currently assigned to records.");

            entity.IsDeleted = true;
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return (true, null);
        }
    }
}