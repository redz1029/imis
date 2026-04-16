using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleDetailsService : IService
    {
        /// <summary>
        /// Performs a soft delete by updating the IsDeleted flag.
        /// </summary>
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves all schedule details mapped to DTOs.
        /// </summary>
        Task<List<AuditScheduleDetailsDto>?> GetAll(CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves a specific schedule detail by ID.
        /// </summary>
        Task<AuditScheduleDetailsDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves a paginated list of schedule details.
        /// </summary>
        Task<DtoPageList<AuditScheduleDetailsDto, AuditScheduleDetails, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        /// <summary>
        /// Handles persistence for the detail entity using the shared BaseDto logic.
        /// </summary>
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}