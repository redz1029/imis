using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditPlanEntryModule
{
    public class AuditPlanEntryService : IAuditPlanEntryService
    {
        private readonly IAuditPlanEntryRepository _repository;
        private readonly ImisDbContext _dbContext;

        public AuditPlanEntryService(IAuditPlanEntryRepository repository)
        {
            _repository = repository;
        }

        public AuditPlanEntryService(IAuditPlanEntryRepository repository, ImisDbContext dbContext)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
        }

        #region READ

        public async Task<List<AuditPlanEntryDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (entities == null || !entities.Any()) return null;

            return entities.Select(x => new AuditPlanEntryDto(x)).ToList();
        }

        public async Task<AuditPlanEntryDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new AuditPlanEntryDto(entity) : null;
        }

        public async Task<DtoPageList<AuditPlanEntryDto, AuditPlanEntry, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (result.TotalCount == 0) return null!;

            return DtoPageList<AuditPlanEntryDto, AuditPlanEntry, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }

        public async Task<List<AuditPlanEntryDto>?> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            var entries = await _repository.FilterByAuditPlanId(auditPlanId, cancellationToken).ConfigureAwait(false);
            return entries != null && entries.Any() ? entries.Select(x => new AuditPlanEntryDto(x)).ToList() : null;
        }

        public async Task<List<AuditPlanEntryDto>?> GetByDayNumberAsync(int auditPlanId, int dayNumber, CancellationToken cancellationToken)
        {
            var entries = await _repository.FilterByDayNumber(auditPlanId, dayNumber, cancellationToken).ConfigureAwait(false);
            return entries != null && entries.Any() ? entries.Select(x => new AuditPlanEntryDto(x)).ToList() : null;
        }

        public async Task<List<AuditPlanEntryDto>?> GetByOfficeIdAsync(int officeId, CancellationToken cancellationToken)
        {
            var entries = await _repository.FilterByOfficeId(officeId, cancellationToken).ConfigureAwait(false);
            return entries != null && entries.Any() ? entries.Select(x => new AuditPlanEntryDto(x)).ToList() : null;
        }

        public async Task<List<AuditPlanEntryDto>?> GetByTeamIdAsync(int teamId, CancellationToken cancellationToken)
        {
            var entries = await _repository.FilterByTeamId(teamId, cancellationToken).ConfigureAwait(false);
            return entries != null && entries.Any() ? entries.Select(x => new AuditPlanEntryDto(x)).ToList() : null;
        }

        public async Task<List<AuditPlanEntryDto>?> GetByAuditorIdAsync(string auditorId, CancellationToken cancellationToken)
        {
            var entries = await _repository.FilterByAuditorId(auditorId, cancellationToken).ConfigureAwait(false);
            return entries != null && entries.Any() ? entries.Select(x => new AuditPlanEntryDto(x)).ToList() : null;
        }

        public async Task<List<AuditPlanEntryDto>?> GetByProcessIdAsync(int processId, CancellationToken cancellationToken)
        {
            var entries = await _repository.FilterByProcessId(processId, cancellationToken).ConfigureAwait(false);
            return entries != null && entries.Any() ? entries.Select(x => new AuditPlanEntryDto(x)).ToList() : null;
        }

        public async Task<List<AuditPlanEntryDto>?> GetByResponsiblePersonIdAsync(int personId, CancellationToken cancellationToken)
        {
            var entries = await _repository.FilterByResponsiblePersonId(personId, cancellationToken).ConfigureAwait(false);
            return entries != null && entries.Any() ? entries.Select(x => new AuditPlanEntryDto(x)).ToList() : null;
        }

        public async Task<List<AuditPlanEntryDto>?> GetByIsoStandardIdAsync(int standardId, CancellationToken cancellationToken)
        {
            var entries = await _repository.FilterByIsoStandardId(standardId, cancellationToken).ConfigureAwait(false);
            return entries != null && entries.Any() ? entries.Select(x => new AuditPlanEntryDto(x)).ToList() : null;
        }

        #endregion

        #region COMMANDS

        /// <summary>
        /// Fixes CS0535 and CS4032. 
        /// Routes the base DTO to the specific Create/Update logic of this service.
        /// </summary>
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)where TEntity : Entity<TId>
        {
            // Cast to specific DTO for this service
            if (dto is not AuditPlanEntryDto entryDto) return;

            // Ensure the ID comparison is handled correctly
            if (EqualityComparer<TId>.Default.Equals(dto.Id, default))
            {
                // Logic for Create
                var entity = entryDto.ToEntity();
                _repository.Add(entity); // Fix for CS1061: use Add instead of AddAsync
            }
            else
            {
                // Logic for Update
                var id = (int)(object)dto.Id; // Cast TId to int
                var entity = entryDto.ToEntity();
                await _repository.UpdateAsync(entity, id, cancellationToken).ConfigureAwait(false);
            }

           
        }
        

        public async Task<AuditPlanEntryDto> CreateAsync(AuditPlanEntryDto entryDto, CancellationToken cancellationToken)
        {
            var entity = entryDto.ToEntity();
            _dbContext.Add(entity);
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return new AuditPlanEntryDto(entity);
        }

        public async Task<AuditPlanEntryDto> UpdateAsync(AuditPlanEntryDto dto, CancellationToken cancellationToken)
        {
            var incoming = dto.ToEntity();
            var existing = await _repository.GetWithDetailsAsync(dto.Id, cancellationToken).ConfigureAwait(false)
                           ?? throw new InvalidOperationException("Audit Plan Entry not found.");

            _dbContext.Entry(existing).CurrentValues.SetValues(incoming);

            // Synchronize child collections
            UpdateCollection(existing.Auditors, incoming.Auditors);
            UpdateCollection(existing.IsoStandards, incoming.IsoStandards);
            UpdateCollection(existing.AuditPlanProcesses, incoming.AuditPlanProcesses);
            UpdateCollection(existing.ResposiblePersons, incoming.ResposiblePersons);

            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return new AuditPlanEntryDto(existing);
        }

        public async Task<List<AuditPlanEntryDto>> CreateMultipleAsync(List<AuditPlanEntryDto> entriesDto, CancellationToken cancellationToken)
        {
            var entities = entriesDto.Select(x => x.ToEntity()).ToList();
            _dbContext.AddRange(entities);
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return entities.Select(x => new AuditPlanEntryDto(x)).ToList();
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entry = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entry == null) return false;

            entry.IsDeleted = true;
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return true;
        }

        #endregion

        /// <summary>
        /// Fixes 'IMIS.Domain.User' reference conversion error.
        /// Uses 'dynamic' to access Id and IsDeleted regardless of the base class.
        /// </summary>
        private void UpdateCollection<T>(List<T>? existingList, List<T>? incomingList) where T : class
        {
            if (existingList == null) return;
            var incomingListSafe = incomingList ?? new List<T>();

            // 1. Handle Deletions and Updates
            foreach (var existingItem in existingList.ToList())
            {
                dynamic existingDyn = existingItem;
                var match = incomingListSafe.FirstOrDefault(i => ((dynamic)i).Id == existingDyn.Id && ((dynamic)i).Id != 0);

                if (match == null)
                {
                    existingDyn.IsDeleted = true;
                }
                else
                {
                    bool wasDeleted = existingDyn.IsDeleted;
                    _dbContext.Entry(existingItem).CurrentValues.SetValues((object)match);
                    existingDyn.IsDeleted = wasDeleted;
                }
            }

            // 2. Handle Additions
            foreach (var incomingItem in incomingListSafe)
            {
                dynamic incomingDyn = incomingItem;
                if (incomingDyn.Id == 0)
                {
                    existingList.Add(incomingItem);
                }
            }
        }
    }
}