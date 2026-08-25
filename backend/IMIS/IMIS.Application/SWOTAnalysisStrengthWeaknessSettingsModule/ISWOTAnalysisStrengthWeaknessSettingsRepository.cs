using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisStrengthWeaknessModule
{
    public interface ISWOTAnalysisStrengthWeaknessSettingsRepository : IRepository<SWOTAnalysisStrengthWeaknessSettings, int>
    {
        Task<EntityPageList<SWOTAnalysisStrengthWeaknessSettings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<SWOTAnalysisStrengthWeaknessSettings>> GetAll(CancellationToken cancellationToken);
        Task<SWOTAnalysisStrengthWeaknessSettings?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
