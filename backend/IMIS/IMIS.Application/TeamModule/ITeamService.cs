using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;

namespace IMIS.Application.TeamModule
{
    public interface ITeamService : IService
    {
        public Task<DtoPageList<TeamDto, Team, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<TeamDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<TeamDto>?> GetAllActiveAsync(CancellationToken cancellationToken);
        Task<TeamDto> SaveOrUpdateAsync(TeamDto team, CancellationToken cancellationToken);
        Task<List<TeamDto>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
        Task<TeamDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
    }
}
