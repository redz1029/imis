using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsKraModule
{
    public interface IKraRepository : IRepository<Kra, int>
    {       
        Task<IEnumerable<Kra>> GetAll(CancellationToken cancellationToken);
        new  Task<Kra> SaveOrUpdateAsync(Kra kra, CancellationToken cancellationToken);
    }   
}
