using Base.Abstractions;

namespace IMIS.Application.TeamModule
{
    public interface ITeamService : IService
    {
        Task<List<TeamDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<TeamDto>?> GetAllActiveAsync(CancellationToken cancellationToken);
    }
}
