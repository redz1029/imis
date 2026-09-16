using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditProgrammeStatusHistoryModule
{
    public interface IAuditProgrammeStatusHistoryRepository : IRepository<AuditProgrammeStatusHistory, int>
    {
        Task<IEnumerable<AuditProgrammeStatusHistory>> GetByProgrammeIdAsync(int auditProgrammeId, CancellationToken cancellationToken);
        Task<EntityPageList<AuditProgrammeStatusHistory, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<AuditProgrammeStatusHistory?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
    }
}