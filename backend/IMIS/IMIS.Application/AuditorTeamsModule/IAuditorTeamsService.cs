using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditorTeamsModule
{
    public interface IAuditorTeamsService : IService
    {
        Task<List<AuditorTeamsDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<AuditorTeamsDto>> GetAllAsyncFilterByTeamId(long? teamId, CancellationToken cancellationToken);
        public Task<DtoPageList<AuditorTeamsDto, AuditorTeams, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
