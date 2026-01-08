using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapRoleAssignmentModule
{
    public interface IKraRoadMapRoleRepository : IRepository<KraRoadMapRole, int>
    {
        //Task<KraRoadMapRole?> GetByRoleIdAsync(string roleId, CancellationToken cancellationToken);
        Task<List<KraRoadMapRole>> GetByRoleIdAsync(string roleId, CancellationToken cancellationToken);
        Task<IEnumerable<KraRoadMapRole>?> GetAll(CancellationToken cancellationToken);
    }
}
