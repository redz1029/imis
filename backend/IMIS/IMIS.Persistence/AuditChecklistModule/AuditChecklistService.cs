using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditChecklistModule;
using IMIS.Application.AuditChecklistQNAModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.IQASignatoryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditChecklistModule
{
    public class AuditChecklistService : IAuditChecklistService
    {
        private readonly IAuditChecklistRepository _repository;
        private readonly IAuditChecklistQNARepository _qnaRepository;
        private readonly ImisDbContext _dbContext;

        public AuditChecklistService(
            IAuditChecklistRepository repository,
            IAuditChecklistQNARepository qnaRepository,
            ImisDbContext dbContext)
        {
            _repository = repository;
            _qnaRepository = qnaRepository;
            _dbContext = dbContext;
        }

        public async Task<AuditChecklistDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new AuditChecklistDto(entity);
        }

        public async Task<object?> GetByProcessIdAsync(int processId, CancellationToken cancellationToken)
        {
            var checklists = await _repository.GetByProcessIdAsync(processId, cancellationToken).ConfigureAwait(false);
            return checklists.Select(x => new AuditChecklistDto(x));
        }

        public async Task<IEnumerable<AuditChecklistDto>> GetOrGenerateForAuditPlanEntryAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            var existing = (await _repository.GetByAuditPlanEntryIdAsync(auditPlanEntryId, cancellationToken).ConfigureAwait(false)).ToList();
            if (existing.Any())
            {
                return existing.Select(x => new AuditChecklistDto(x));
            }

            // Gating Rule: Verify that the Audit Schedule exists and has been Confirmed/Approved
            var schedule = await _dbContext.Set<AuditSchedule>()
                .Where(s => s.AuditPlanEntryId == auditPlanEntryId && !s.IsDeleted)
                .Select(s => new { s.Id, s.AuditPlanId })
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false);

            if (schedule == null)
            {
                throw new InvalidOperationException(
                    $"No Audit Schedule exists for Audit Plan Entry {auditPlanEntryId}. " +
                    "A schedule must be created and confirmed for this entry before its checklist can be generated.");
            }

            var scheduleState = await IQAApprovalWorkflow.GetStateCodeAsync(
                _dbContext, IQAApprovalWorkflow.EntityTypes.AuditSchedule, schedule.Id, cancellationToken);

            if (scheduleState != IQAApprovalWorkflow.StateCodes.Confirmed &&
                scheduleState != IQAApprovalWorkflow.StateCodes.Approved)
            {
                throw new InvalidOperationException(
                    $"Audit Schedule #{schedule.Id} is in status '{IQAApprovalWorkflow.StateName(scheduleState, IQAApprovalWorkflow.EntityTypes.AuditSchedule)}'. " +
                    "A schedule must be confirmed by the Department Head (or approved) before generating its checklist.");
            }

            var entry = await _dbContext.Set<AuditPlanEntry>()
                .Include(e => e.IsoStandardAuditPlans)
                .FirstOrDefaultAsync(e => e.Id == auditPlanEntryId, cancellationToken)
                .ConfigureAwait(false);

            if (entry?.IsoStandardAuditPlans == null || !entry.IsoStandardAuditPlans.Any())
            {
                return Enumerable.Empty<AuditChecklistDto>();
            }

            var standardIds = entry.IsoStandardAuditPlans
                .Select(s => s.IsoStandardId)
                .Where(id => id != null)
                .Select(id => id!.Value)
                .Distinct()
                .ToList();

            var newRows = new List<AuditChecklist>();
            foreach (var stdId in standardIds)
            {
                var rawQuestions = await _qnaRepository.GetByIsoStandardIdAsync(stdId, cancellationToken).ConfigureAwait(false);
                var questions = rawQuestions.OfType<AuditChecklistQNA>();

                foreach (var q in questions)
                {
                    newRows.Add(new AuditChecklist
                    {
                        Id = 0,
                        AuditPlanEntryId = auditPlanEntryId,
                        AuditScheduleId = schedule.Id,
                        AuditChecklistQNAId = q.Id,
                        Conforming = null,
                        FindingAndRemarks = null
                    });
                }
            }

            foreach (var row in newRows)
            {
                _repository.Add(row);
            }

            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            var saved = await _repository.GetByAuditPlanEntryIdAsync(auditPlanEntryId, cancellationToken).ConfigureAwait(false);
            return saved.Select(x => new AuditChecklistDto(x));
        }

        public async Task<bool> SaveChecklistAsync(AuditChecklistDto dto, CancellationToken cancellationToken)
        {
            var entity = dto.ToEntity();

            if (entity.Id == 0)
            {
                _repository.Add(entity);
            }
            else
            {
                var existing = await _repository.GetByIdAsync(entity.Id, cancellationToken).ConfigureAwait(false);
                if (existing == null) return false;

                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<DtoPageList<AuditChecklistDto, AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<AuditChecklistDto, AuditChecklist, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            await _repository.DeleteAsync(entity, cancellationToken).ConfigureAwait(false);
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is AuditChecklistDto checklistDto)
            {
                await SaveChecklistAsync(checklistDto, cancellationToken).ConfigureAwait(false);
            }
        }

        public async Task<IEnumerable<AuditChecklistDto>> GetByAuditeeIdAsync(int auditeeId, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByAuditeeIdAsync(auditeeId, cancellationToken).ConfigureAwait(false);
            return entities.Select(x => new AuditChecklistDto(x));
        }

        public async Task<IEnumerable<AuditChecklistDto>> GetByAuditScheduleIdAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByAuditScheduleIdAsync(auditScheduleId, cancellationToken).ConfigureAwait(false);
            return entities.Select(x => new AuditChecklistDto(x));
        }
        public async Task<ReportAuditChecklistDto?> ReportGetByAuditScheduleIdAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            
            var entities = await _repository.GetByAuditScheduleIdAsync(auditScheduleId, cancellationToken).ConfigureAwait(false);
            var list = entities.ToList();
            return list.Any() ? new ReportAuditChecklistDto(list) : null;
        }
    }
}
