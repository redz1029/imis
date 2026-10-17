using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditComFindingsModule
{
    public interface IAuditComFindingsService : IService
    {
        Task<AuditComFindingsDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SaveComFindingsAsync(AuditComFindingsDto dto, CancellationToken cancellationToken);
        Task<DtoPageList<AuditComFindingsDto, AuditComFindings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}