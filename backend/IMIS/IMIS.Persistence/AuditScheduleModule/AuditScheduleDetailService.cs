using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditScheduleModule;
using IMIS.Domain;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditScheduleModule
{
    public class AuditScheduleDetailsService : IAuditScheduleDetailsService
    {
        private readonly IAuditScheduleDetailsRepository _auditScheduleDetailsRepository;

        public AuditScheduleDetailsService(IAuditScheduleDetailsRepository auditScheduleDetailsRepository)
        {
            _auditScheduleDetailsRepository = auditScheduleDetailsRepository;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _auditScheduleDetailsRepository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null)
                return false;

            entity.IsDeleted = true;

            // Using the DbContext from the repository to persist the soft delete change
            var context = _auditScheduleDetailsRepository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return true;
        }

        public async Task<List<AuditScheduleDetailsDto>?> GetAll(CancellationToken cancellationToken)
        {
            var entities = await _auditScheduleDetailsRepository.GetAll(cancellationToken).ConfigureAwait(false);
            return entities?.Select(e => new AuditScheduleDetailsDto(e)).ToList();
        }

        public async Task<AuditScheduleDetailsDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _auditScheduleDetailsRepository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new AuditScheduleDetailsDto(entity) : null;
        }

        public async Task<DtoPageList<AuditScheduleDetailsDto, AuditScheduleDetails, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _auditScheduleDetailsRepository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            if (pagedEntities.TotalCount == 0)
            {
                return null;
            }

            return DtoPageList<AuditScheduleDetailsDto, AuditScheduleDetails, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var detailsDto = dto as AuditScheduleDetailsDto;

            // Map DTO to Entity
            var entity = detailsDto!.ToEntity();

            if (entity.Id == 0)
            {
                _auditScheduleDetailsRepository.Add(entity);
            }
            else
            {
                // Ensure the update reflects existing tracked changes and handles concurrency
                await _auditScheduleDetailsRepository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            // Persist changes to the database
            await _auditScheduleDetailsRepository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }
    }
}