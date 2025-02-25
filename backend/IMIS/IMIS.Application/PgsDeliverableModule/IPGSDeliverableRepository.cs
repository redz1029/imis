using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPGSDeliverableRepository : IRepository<PgsDeliverable, long>
    {
        Task<List<PgsDeliverable>?> GetAll(CancellationToken cancellationToken);
        new Task<PgsDeliverable> SaveOrUpdateAsync(PgsDeliverable pgs, CancellationToken cancellationToken);
    }
}


