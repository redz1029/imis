using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditStatusModule
{
    public interface IAuditStatusService : IService
    {
        Task<List<AuditStatusDto>> GetAllAsync(CancellationToken cancellationToken);

        Task<DtoPageList<AuditStatusDto, AuditStatus, int>> GetPaginatedAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}