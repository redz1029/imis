using Base.Abstractions;

namespace IMIS.Application.BreakThroughScoringModule
{
    public interface IBreakThroughScoringService : IService
    {
        Task<BreakThroughScoringDto?> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken);
        Task<BreakThroughScoringDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
    }
}
