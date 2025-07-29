using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableHistoryModule
{
    public interface IPgsDeliverableHistoryRepository : IRepository<PgsDeliverableHistory, long>
    {
        Task<List<PgsDeliverableHistory>> GetByIdAsync(int id, CancellationToken cancellationToken);
        new Task<PgsDeliverableHistory> SaveOrUpdateAsync(PgsDeliverableHistory pgsDeliverableHistory, CancellationToken cancellationToken);
    }
}
