using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanApprovalModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditPlanApprovalModule
{
    public class AuditPlanApprovalService : IAuditPlanApprovalService
    {
        private readonly IAuditPlanApprovalRepository _auditPlanApprovalRepository;

        public AuditPlanApprovalService(IAuditPlanApprovalRepository auditPlanApprovalRepository)
        {
            _auditPlanApprovalRepository = auditPlanApprovalRepository;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _auditPlanApprovalRepository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null)
                return false;

            entity.IsDeleted = true;

            // Using the DbContext from the repository to persist the soft delete change
            var context = _auditPlanApprovalRepository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return true;
        }

        public async Task<List<AuditPlanApprovalDto>?> GetAll(CancellationToken cancellationToken)
        {
            var entities = await _auditPlanApprovalRepository.GetAll(cancellationToken).ConfigureAwait(false);
            return entities?.Select(e => new AuditPlanApprovalDto(e)).ToList();
        }

        public async Task<AuditPlanApprovalDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _auditPlanApprovalRepository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new AuditPlanApprovalDto(entity) : null;
        }

        public async Task<DtoPageList<AuditPlanApprovalDto, AuditPlanApproval, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _auditPlanApprovalRepository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            if (pagedEntities.TotalCount == 0)
            {
                return null;
            }

            return DtoPageList<AuditPlanApprovalDto, AuditPlanApproval, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var approvalDto = dto as AuditPlanApprovalDto;
            // Map DTO to Entity
            var entity = approvalDto!.ToEntity();

            if (entity.Id == 0)
            {
                _auditPlanApprovalRepository.Add(entity);
            }
            else
            {
                // Ensure the update reflects existing tracked changes and handles concurrency
                await _auditPlanApprovalRepository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            // Persist changes to the database
            await _auditPlanApprovalRepository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }
    }
}