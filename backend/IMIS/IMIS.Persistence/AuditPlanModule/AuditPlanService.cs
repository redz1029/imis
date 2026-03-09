using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditPlanModule
{
    public class AuditPlanService : IAuditPlanService
    {
        private readonly IAuditPlanRepository _repository;

        public AuditPlanService(IAuditPlanRepository repository)
        {
            _repository = repository;
        }

        #region SOFT DELETE

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var auditPlan = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (auditPlan == null) return false;

            auditPlan.IsDeleted = true;
            // Accessing the context through the repository's base capability
            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);
            return true;
        }

        #endregion

        #region GET METHODS

        public async Task<List<AuditPlanDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var auditPlans = await _repository.GetAllAsync(cancellationToken);
            return auditPlans?.Select(x => new AuditPlanDto(x)).ToList();
        }

        public async Task<AuditPlanDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var auditPlan = await _repository.GetByIdAsync(id, cancellationToken);
            return auditPlan != null ? new AuditPlanDto(auditPlan) : null;
        }

        public async Task<AuditPlanDto?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            var auditPlan = await _repository.GetByIdWithDetailsAsync(id, cancellationToken);
            return auditPlan != null ? new AuditPlanDto(auditPlan) : null;
        }

        public async Task<List<AuditPlanDto>?> GetByPreparerIdAsync(string preparerId, CancellationToken cancellationToken)
        {
            var plans = await _repository.GetByPreparerIdAsync(preparerId, cancellationToken);
            return plans?.Select(x => new AuditPlanDto(x)).ToList();
        }

        public async Task<List<AuditPlanDto>?> GetByApproverIdAsync(string approverId, CancellationToken cancellationToken)
        {
            var plans = await _repository.GetByApproverIdAsync(approverId, cancellationToken);
            return plans?.Select(x => new AuditPlanDto(x)).ToList();
        }

        public async Task<List<AuditPlanDto>?> GetByStatusAsync(string status, CancellationToken cancellationToken)
        {
            var plans = await _repository.GetByStatusAsync(status, cancellationToken);
            return plans?.Select(x => new AuditPlanDto(x)).ToList();
        }

        public async Task<List<AuditPlanDto>?> GetByDateRangeAsync(DateTime startDate, DateTime endDate, CancellationToken cancellationToken)
        {
            var plans = await _repository.GetByDateRangeAsync(startDate, endDate, cancellationToken);
            return plans?.Select(x => new AuditPlanDto(x)).ToList();
        }

        public async Task<DtoPageList<AuditPlanDto, AuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            return DtoPageList<AuditPlanDto, AuditPlan, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }

        #endregion

        #region CREATE & UPDATE

        public async Task<AuditPlanDto> CreateAsync(AuditPlanDto dto, CancellationToken cancellationToken)
        {
            var entity = dto.ToEntity();
            entity.CreatedDate = DateTime.UtcNow;
            entity.PlanStatus = "Draft"; // Domain uses string now
            entity.IsDeleted = false;

            _repository.Add(entity);
            await _repository.SaveOrUpdateAsync(entity, cancellationToken);

            return new AuditPlanDto(entity);
        }

        public async Task<AuditPlanDto> UpdateAsync(AuditPlanDto dto, CancellationToken cancellationToken)
        {
            var existing = await _repository.GetByIdAsync(dto.Id, cancellationToken);
            if (existing == null) throw new KeyNotFoundException($"AuditPlan with ID {dto.Id} not found.");

            // Update the entity fields from DTO
            existing.StartDate = dto.StartDate;
            existing.EndDate = dto.EndDate;
            existing.SelectedApproverId = dto.SelectedApproverId;
            existing.LastModifiedDate = DateTime.UtcNow;

            await _repository.UpdateAsync(existing, existing.Id, cancellationToken);
            await _repository.SaveOrUpdateAsync(existing, cancellationToken);

            return new AuditPlanDto(existing);
        }

        #endregion

        #region WORKFLOW

        public async Task<AuditPlanDto?> SubmitForApprovalAsync(int id, CancellationToken cancellationToken)
        {
            var auditPlan = await _repository.GetByIdAsync(id, cancellationToken);
            if (auditPlan == null) return null;

            auditPlan.PlanStatus = "Pending Approval";
            auditPlan.LastModifiedDate = DateTime.UtcNow;

            await _repository.UpdateAsync(auditPlan, auditPlan.Id, cancellationToken);
            await _repository.SaveOrUpdateAsync(auditPlan, cancellationToken);

            return new AuditPlanDto(auditPlan);
        }

        public async Task<AuditPlanDto?> ApproveAsync(int id, string approverId, CancellationToken cancellationToken)
        {
            var auditPlan = await _repository.GetByIdAsync(id, cancellationToken);
            if (auditPlan == null) return null;

            auditPlan.PlanStatus = "Approved";
            auditPlan.LastModifiedDate = DateTime.UtcNow;

            await _repository.UpdateAsync(auditPlan, auditPlan.Id, cancellationToken);
            await _repository.SaveOrUpdateAsync(auditPlan, cancellationToken);

            return new AuditPlanDto(auditPlan);
        }

        public async Task<AuditPlanDto?> RejectAsync(int id, string approverId, string comments, CancellationToken cancellationToken)
        {
            var auditPlan = await _repository.GetByIdAsync(id, cancellationToken);
            if (auditPlan == null) return null;

            auditPlan.PlanStatus = "Draft"; // Return to draft status
            auditPlan.LastModifiedDate = DateTime.UtcNow;

            // Note: If you have an AuditPlanApproval table, you would add a record here with the 'comments'

            await _repository.UpdateAsync(auditPlan, auditPlan.Id, cancellationToken);
            await _repository.SaveOrUpdateAsync(auditPlan, cancellationToken);

            return new AuditPlanDto(auditPlan);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is AuditPlanDto planDto)
            {
                if (planDto.Id == 0)
                {
                    // Routes to the logic that sets "Draft" status and CreatedDate
                    await CreateAsync(planDto, cancellationToken).ConfigureAwait(false);
                }
                else
                {
                    // Routes to the logic that updates fields and LastModifiedDate
                    await UpdateAsync(planDto, cancellationToken).ConfigureAwait(false);
                }
            }
        }

        #endregion
    }
}