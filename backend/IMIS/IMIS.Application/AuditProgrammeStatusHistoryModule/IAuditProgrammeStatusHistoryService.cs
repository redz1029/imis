using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditProgrammeStatusHistoryModule
{
    public interface IAuditProgrammeStatusHistoryService : IService
    {
        Task<List<AuditProgrammeStatusHistoryDto>> GetByProgrammeIdAsync(int auditProgrammeId, CancellationToken cancellationToken);

        Task<DtoPageList<AuditProgrammeStatusHistoryDto, AuditProgrammeStatusHistory, int>> GetPaginatedAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken);

        Task<(bool Success, string? Error)> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}