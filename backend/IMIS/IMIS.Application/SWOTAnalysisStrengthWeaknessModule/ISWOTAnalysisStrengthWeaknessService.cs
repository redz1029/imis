using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisStrengthWeaknessModule
{
    public interface ISWOTAnalysisStrengthWeaknessService : IService
    {
        public Task<DtoPageList<SWOTAnalysisStrengthWeaknessDto, SWOTAnalysisStrengthWeakness, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<SWOTAnalysisStrengthWeaknessDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<SWOTAnalysisStrengthWeaknessDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
