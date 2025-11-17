using Base.Abstractions;

namespace IMIS.Application.SWOTAnalysisModule
{
    public interface ISWOTAnalysisService : IService
    {
        Task<SWOTAnalysisDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<SWOTAnalysisDto>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken);
    }
}
