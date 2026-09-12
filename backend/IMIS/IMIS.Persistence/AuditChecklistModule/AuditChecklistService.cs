using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditChecklistModule;
using IMIS.Application.AuditChecklistQNAModule;
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
            // Queries AuditPlanEntry processes matching processId / officeId
            var checklists = await _dbContext.Set<AuditChecklist>()
                .Include(c => c.AuditChecklistQNA)
                .Include(c => c.AuditPlanEntry)
                    .ThenInclude(e => e!.AuditPlanProcesses)
                        .ThenInclude(p => p.Office)
                .Where(c => c.AuditPlanEntry != null && 
                            c.AuditPlanEntry.AuditPlanProcesses.Any(p => p.OfficeId == processId || p.Id == processId))
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            return checklists.Select(x => new AuditChecklistDto(x));
        }

        public async Task<IEnumerable<AuditChecklistDto>> GetOrGenerateForAuditPlanEntryAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            var existing = (await _repository.GetByAuditPlanEntryIdAsync(auditPlanEntryId, cancellationToken).ConfigureAwait(false)).ToList();
            if (existing.Any())
            {
                return existing.Select(x => new AuditChecklistDto(x));
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
    }
}