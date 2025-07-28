using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableHistoryModule
{
    public interface IPgsDeliverableHistoryRepository : IRepository<PgsDeliverableHistory, long>
    {

        new Task<PgsDeliverableHistory> SaveOrUpdateAsync(PgsDeliverableHistory pgsDeliverableHistory, CancellationToken cancellationToken);
    }
}
