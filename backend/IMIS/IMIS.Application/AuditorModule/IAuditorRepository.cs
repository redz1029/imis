using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.AuditorModule
{
    public interface IAuditorRepository : IRepository<Auditor, int>
    {
        Task<IEnumerable<Auditor>?> GetAll(CancellationToken cancellationToken);
        Task<IEnumerable<Auditor>?> FilteByName(string name, int noOfResults, CancellationToken cancellationToken);
    }
}
