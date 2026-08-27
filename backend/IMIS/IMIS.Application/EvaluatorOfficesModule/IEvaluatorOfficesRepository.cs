using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.EvaluatorOfficesModule
{
    public interface IEvaluatorOfficesRepository : IRepository<EvaluatorOffices, int>
    {
        Task<EntityPageList<EvaluatorOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<EvaluatorOffices>> GetAll(CancellationToken cancellationToken);
        Task<IEnumerable<EvaluatorOffices>> GetAllServicesAsync(CancellationToken cancellationToken);
        Task<IEnumerable<EvaluatorOffices>> GetServicesByUserIdAsync(string userId, CancellationToken cancellationToken);
        Task<EvaluatorOffices?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<EvaluatorOffices?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
    }
}
