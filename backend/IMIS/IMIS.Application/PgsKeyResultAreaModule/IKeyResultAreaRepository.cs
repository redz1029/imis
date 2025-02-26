using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsKraModule
{
    public interface IKeyResultAreaRepository : IRepository<KeyResultArea, int>
    {       
        Task<IEnumerable<KeyResultArea>> GetAll(CancellationToken cancellationToken);
        new  Task<KeyResultArea> SaveOrUpdateAsync(KeyResultArea kra, CancellationToken cancellationToken);
    }   
}
