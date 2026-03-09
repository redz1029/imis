using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanApprovalModule;
using IMIS.Application.IsoStandardModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditPlanApprovalModule
{
    public class AuditPlanApprovalService : IAuditPlanApprovalService
    {
        
        private readonly ImisDbContext _dbContext;
        private readonly IAuditPlanApprovalRepository _repository;

        private const string ApproveAction = "Approve";
        private const string RejectAction = "Reject";
        private const string ReviewAction = "Review";

        private static readonly HashSet<string> AllowedActions = new()
        {
            ApproveAction,
            RejectAction,
            ReviewAction
        };

       
        public AuditPlanApprovalService(IAuditPlanApprovalRepository repository, ImisDbContext dbContext)
        {
            _repository = repository;
            _dbContext = dbContext;
        }

        // =====================================================
        // GET METHODS
        // =====================================================

        public async Task<DtoPageList<AuditPlanApprovalDto, AuditPlanApproval, int>>
            GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken = default)
        {
            if (page <= 0) throw new ArgumentException("Page must be greater than zero.");
            if (pageSize <= 0) throw new ArgumentException("PageSize must be greater than zero.");

            var result = await _repository
                .GetPaginatedAsync(page, pageSize, cancellationToken)
                .ConfigureAwait(false);

            return DtoPageList<AuditPlanApprovalDto, AuditPlanApproval, int>
                .Create(result.Items, page, pageSize, result.TotalCount);
        }

        public async Task<List<AuditPlanApprovalDto>> GetAllAsync(CancellationToken cancellationToken = default)
        {
            var approvals = await _repository
                .GetAllAsync(cancellationToken)
                .ConfigureAwait(false);

            return approvals.Select(x => new AuditPlanApprovalDto(x)).ToList();
        }

        public async Task<AuditPlanApprovalDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            if (id <= 0) return null;

            var approval = await _repository
                .GetByIdAsync(id, cancellationToken)
                .ConfigureAwait(false);

            return approval == null ? null : new AuditPlanApprovalDto(approval);
        }

        public async Task<List<AuditPlanApprovalDto>> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken = default)
        {
            if (auditPlanId <= 0)
                return new List<AuditPlanApprovalDto>();

            var approvals = await _repository
                .GetByAuditPlanIdAsync(auditPlanId, cancellationToken)
                .ConfigureAwait(false);

            return approvals.Select(x => new AuditPlanApprovalDto(x)).ToList();
        }

        public async Task<List<AuditPlanApprovalDto>> GetByApproverIdAsync(int approverId, CancellationToken cancellationToken = default)
        {
            if (approverId <= 0)
                return new List<AuditPlanApprovalDto>();

            var approvals = await _repository
                .GetByApproverIdAsync(approverId, cancellationToken)
                .ConfigureAwait(false);

            return approvals.Select(x => new AuditPlanApprovalDto(x)).ToList();
        }

        public async Task<List<AuditPlanApprovalDto>> GetByActionAsync(string action, CancellationToken cancellationToken = default)
        {
            ValidateAction(action);

            var approvals = await _repository
                .GetByActionAsync(action, cancellationToken)
                .ConfigureAwait(false);

            return approvals.Select(x => new AuditPlanApprovalDto(x)).ToList();
        }

        public async Task<List<AuditPlanApprovalDto>> GetByDateRangeAsync( DateTime startDate,DateTime endDate,CancellationToken cancellationToken = default)
        {
            if (endDate < startDate)
                throw new ArgumentException("EndDate cannot be earlier than StartDate.");

            var approvals = await _repository
                .GetByDateRangeAsync(startDate, endDate, cancellationToken)
                .ConfigureAwait(false);

            return approvals.Select(x => new AuditPlanApprovalDto(x)).ToList();
        }

        public async Task<AuditPlanApprovalDto?> GetByAuditPlanAndApproverAsync(int auditPlanId,int approverId,CancellationToken cancellationToken = default)
        {
            if (auditPlanId <= 0 || approverId <= 0)
                return null;

            var approval = await _repository
                .GetByAuditPlanAndApproverAsync(auditPlanId, approverId, cancellationToken)
                .ConfigureAwait(false);

            return approval == null ? null : new AuditPlanApprovalDto(approval);
        }

        // =====================================================
        // CREATE
        // =====================================================

        public async Task<AuditPlanApprovalDto> CreateApprovalAsync( int auditPlanId,int approverId, string action,string? comments = null,CancellationToken cancellationToken = default)
        {
            // 1. Validate inputs
            ValidateApprovalInput(auditPlanId, approverId, action);

            // 2. Initialize the entity
            // All properties marked 'required' in the class MUST be here
            var approval = new AuditPlanApproval
            {
                Id = auditPlanId,
                AuditPlanId = auditPlanId,
                ApproverId = approverId,
                Action = action,
                Timestamp = DateTime.UtcNow,
                Comments = comments,
                IsDeleted = false
            };

            // 3. Persist to database
            _repository.Add(approval);

            // Use the injected _dbContext or the repository's context to save
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            // 4. Return the DTO
            return new AuditPlanApprovalDto(approval);
        }

        public Task<AuditPlanApprovalDto> CreateApprovalWithSignatureAsync(int auditPlanId,int approverId,string action,string? comments = null,CancellationToken cancellationToken = default)
        {
            return CreateApprovalAsync(auditPlanId, approverId, action, comments, cancellationToken);
        }

        // =====================================================
        // WORKFLOW ACTIONS
        // =====================================================

        public Task<AuditPlanApprovalDto?> ApproveAuditPlanAsync(int auditPlanId,int approverId,string? comments = null,CancellationToken cancellationToken = default)
        {
            return CreateApprovalInternalAsync(auditPlanId, approverId, ApproveAction, comments, cancellationToken);
        }

        public Task<AuditPlanApprovalDto?> RejectAuditPlanAsync(int auditPlanId, int approverId,string comments,CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(comments))
                throw new ArgumentException("Comments are required when rejecting.");

            return CreateApprovalInternalAsync(auditPlanId, approverId, RejectAction, comments, cancellationToken);
        }

        public Task<AuditPlanApprovalDto?> ReviewAuditPlanAsync(int auditPlanId,int approverId,string? comments = null,CancellationToken cancellationToken = default)
        {
            return CreateApprovalInternalAsync(auditPlanId, approverId, ReviewAction, comments, cancellationToken);
        }

        private async Task<AuditPlanApprovalDto?> CreateApprovalInternalAsync(int auditPlanId,int approverId,string action,string? comments,CancellationToken cancellationToken)
        {
            if (await _repository
                .ExistsByAuditPlanAndApproverAsync(auditPlanId, approverId, cancellationToken)
                .ConfigureAwait(false))
            {
                throw new InvalidOperationException(
                    "Approval already exists for this audit plan and approver.");
            }

            return await CreateApprovalAsync(
                auditPlanId,
                approverId,
                action,
                comments,
                cancellationToken).ConfigureAwait(false);
        }

        // =====================================================
        // SOFT DELETE
        // =====================================================

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken = default)
        {
            if (id <= 0) return false;

            var approval = await _repository
                .GetByIdAsync(id, cancellationToken)
                .ConfigureAwait(false);

            if (approval == null) return false;

            approval.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return true;
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as AuditPlanApprovalDto;
            var AuditPlanApprovalDto = ODto!.ToEntity();

            if (AuditPlanApprovalDto.Id == 0)
                _repository.Add(AuditPlanApprovalDto);
            else
                await _repository.UpdateAsync(AuditPlanApprovalDto, AuditPlanApprovalDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(AuditPlanApprovalDto, cancellationToken).ConfigureAwait(false);
        }
        // =====================================================
        // EXISTS
        // =====================================================

        public Task<bool> ExistsByAuditPlanAndApproverAsync(int auditPlanId,int approverId,CancellationToken cancellationToken = default)
        {
            return _repository
                .ExistsByAuditPlanAndApproverAsync(auditPlanId, approverId, cancellationToken);
        }


        // =====================================================
        // VALIDATION
        // =====================================================

        private static void ValidateApprovalInput(int auditPlanId, int approverId, string action)
        {
            if (auditPlanId <= 0)
                throw new ArgumentException("Invalid AuditPlanId.");

            if (approverId <= 0)
                throw new ArgumentException("Invalid ApproverId.");

            ValidateAction(action);
        }

        private static void ValidateAction(string action)
        {
            if (string.IsNullOrWhiteSpace(action))
                throw new ArgumentException("Action is required.");

            if (!AllowedActions.Contains(action))
                throw new ArgumentException("Action must be Approve, Reject, or Review.");
        }
        
    }
}