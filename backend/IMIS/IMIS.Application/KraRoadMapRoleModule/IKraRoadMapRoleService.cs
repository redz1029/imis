using Base.Abstractions;

namespace IMIS.Application.KraRoadMapRoleAssignmentModule
{
    public interface IKraRoadMapRoleService : IService
    {
        Task<List<KraRoadMapRoleDto>> GetAllRoadmapForUserAsync(CancellationToken cancellationToken);
    }
}
