using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ImprovementTypeModule
{
    public interface IImprovementTypeService : IService
    {
        Task<List<ImprovementTypeDTO>?> GetAllAsync(CancellationToken cancellationToken);
        Task<DtoPageList<ImprovementTypeDTO, ImprovementType, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
