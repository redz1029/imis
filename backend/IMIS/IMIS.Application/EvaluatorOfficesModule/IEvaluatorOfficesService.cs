using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.EvaluatorOfficesModule
{
    public interface IEvaluatorOfficesService : IService
    {
        public Task<DtoPageList<EvaluatorOfficesDto, EvaluatorOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<EvaluatorOfficesDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<EvaluatorOfficesDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<EvaluatorOfficesDto>?> GetAllServicesAsync(CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
