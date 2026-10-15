using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditPlanEntryModule
{
    public interface IAuditPlanEntryService : IService
    {
        // Get all audit plan entries
        Task<List<AuditPlanEntryDto>?> GetAllAsync(CancellationToken cancellationToken);

        // Validate conflicts (duplicate auditors, processes, missing collections, etc.)
        Task<List<string>> GetConflictValidationsAsync(AuditPlanEntryDto dto, CancellationToken cancellationToken);

        // Get all audit plan entries by AuditPlanId
        Task<List<AuditPlanEntryDto>?> GetAllByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken);

        // Get a single audit plan entry by Id
        Task<AuditPlanEntryDto?> GetByAuditPlanEntryIdAsync(int id, CancellationToken cancellationToken);

        // Soft delete an audit plan entry
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        // Save or update an audit plan entry and its child collections
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;

        // Get paginated list of audit plan entries
        Task<DtoPageList<AuditPlanEntryDto, AuditPlanEntry, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // Save audit plan entry details (wrapper for SaveOrUpdateAsync)
        Task<bool> SaveAuditPlanEntryDetailsAsync(AuditPlanEntryDto dto, CancellationToken cancellationToken);
    }
}