using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditReportModule
{
    public interface IAuditReportService : IService
    {
        Task<AuditReportDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SaveAuditReportAsync(AuditReportDto dto, CancellationToken cancellationToken);
        Task<DtoPageList<AuditReportDto, AuditReport, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}