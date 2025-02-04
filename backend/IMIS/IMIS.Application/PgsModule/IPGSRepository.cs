using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPGSRepository : IRepository<PGS, int>
    {
        Task<IEnumerable<PGS>> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<PGS>> GetAllActiveAsync(CancellationToken cancellationToken);
        Task<PGS> CreateAsync(PGS pgs, CancellationToken cancellationToken);


    }
}


