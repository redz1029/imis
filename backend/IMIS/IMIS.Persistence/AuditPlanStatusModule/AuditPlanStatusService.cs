using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanStatusModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditPlanStatusModule
{
    public class AuditPlanStatusService : IAuditPlanStatusService
    {
        private readonly IAuditPlanStatusRepository _repository;

        public AuditPlanStatusService(IAuditPlanStatusRepository repository)
        {
            _repository = repository;
        }

        public async Task<List<AuditPlanStatusDTO>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var auditPlanStatuses = await _repository.GetAll(cancellationToken).ConfigureAwait(false);

            if (auditPlanStatuses == null)
                return null;

            return auditPlanStatuses.Select(x => new AuditPlanStatusDTO(x)).ToList();
        }

        public async Task<DtoPageList<AuditPlanStatusDTO, AuditPlanStatus, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var auditPlanStatuses = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            if (auditPlanStatuses.TotalCount == 0)
            {
                return null;
            }

            return DtoPageList<AuditPlanStatusDTO, AuditPlanStatus, int>.Create(
                auditPlanStatuses.Items,
                page,
                pageSize,
                auditPlanStatuses.TotalCount);
        }

        public Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var oDto = dto as AuditPlanStatusDTO;
            if (oDto == null)
                throw new ArgumentException("Invalid DTO type. Expected AuditPlanStatusDTO.");

            var auditPlanStatus = oDto.ToEntity();

            if (auditPlanStatus.Id == 0)
                _repository.Add(auditPlanStatus);
            else
                return UpdateAndSaveAsync(auditPlanStatus, cancellationToken);

            return _repository.SaveOrUpdateAsync(auditPlanStatus, cancellationToken);
        }

        private async Task UpdateAndSaveAsync(AuditPlanStatus auditPlanStatus, CancellationToken cancellationToken)
        {
            await _repository.UpdateAsync(auditPlanStatus, auditPlanStatus.Id, cancellationToken).ConfigureAwait(false);
            await _repository.SaveOrUpdateAsync(auditPlanStatus, cancellationToken).ConfigureAwait(false);
        }
    }
}