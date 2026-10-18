using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditeeModule
{
    public interface IAuditeeRepository : IRepository<Auditee, int>
    {
        Task<IEnumerable<Auditee>> GetAll(CancellationToken cancellationToken);

        Task<EntityPageList<Auditee, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<Auditee?> GetWithDetailsAsync(int id, CancellationToken cancellationToken);

        Task<IEnumerable<Auditee>> FilterByUserId(string userId, CancellationToken cancellationToken);

        Task<Auditee?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}