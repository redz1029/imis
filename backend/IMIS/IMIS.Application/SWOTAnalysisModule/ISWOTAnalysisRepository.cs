using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisModule
{
    public interface ISWOTAnalysisRepository : IRepository<SWOTAnalysis, int>
    {
        Task<List<SWOTAnalysis>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken);
        Task<List<SWOTAnalysis>> GetAllAsync(CancellationToken cancellationToken);
    }
}
