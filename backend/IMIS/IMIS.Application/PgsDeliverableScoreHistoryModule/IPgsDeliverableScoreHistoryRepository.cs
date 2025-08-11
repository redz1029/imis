using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableScoreHistoryModule
{
    public interface IPgsDeliverableScoreHistoryRepository : IRepository<PgsDeliverableScoreHistory, long>
    {
        Task<IEnumerable<PgsDeliverableScoreHistory>> GetAll(CancellationToken cancellationToken);
    }
}
