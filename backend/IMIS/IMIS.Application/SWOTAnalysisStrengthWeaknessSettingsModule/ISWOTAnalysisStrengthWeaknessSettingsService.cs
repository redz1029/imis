using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisStrengthWeaknessModule
{
    public interface ISWOTAnalysisStrengthWeaknessSettingsService : IService
    {
        public Task<DtoPageList<SWOTAnalysisStrengthWeaknessSettingsDto, SWOTAnalysisStrengthWeaknessSettings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<SWOTAnalysisStrengthWeaknessSettingsDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<SWOTAnalysisStrengthWeaknessSettingsDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
