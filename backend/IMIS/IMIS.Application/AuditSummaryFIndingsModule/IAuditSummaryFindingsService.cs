using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditSummaryFindingsModule
{
    public interface IAuditSummaryFindingsService : IService
    {
        Task<AuditSummaryFindingsDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SaveSummaryFindingsAsync(AuditSummaryFindingsDto dto, CancellationToken cancellationToken);
        Task<DtoPageList<AuditSummaryFindingsDto, AuditSummaryFIndings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}