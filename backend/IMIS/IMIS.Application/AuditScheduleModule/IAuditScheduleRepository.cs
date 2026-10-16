using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleRepository : IRepository<AuditSchedule, int>
    {
        Task<IEnumerable<AuditSchedule>> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditSchedule>> GetAllActiveAsync(CancellationToken cancellationToken);
        Task AddAuditableOfficesAsync(List<AuditableOffices> auditableOffices, CancellationToken cancellationToken);       
        Task<EntityPageList<AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<AuditSchedule?> GetByAuditScheduleIdAsync(int id, CancellationToken cancellationToken);
        Task<AuditSchedule?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<List<int>> GetExistingAuditableOfficeIdsAsync(long auditScheduleId, CancellationToken cancellationToken);
    }
}

