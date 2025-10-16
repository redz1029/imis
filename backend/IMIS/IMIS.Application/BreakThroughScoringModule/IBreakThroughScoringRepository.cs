using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.BreakThroughScoringModule
{
    public interface IBreakThroughScoringRepository : IRepository<BreakThroughScoring, int>
    {
        Task<BreakThroughScoring?> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken);
    }
}
