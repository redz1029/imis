using Base.Abstractions;

namespace IMIS.Application.AuditorTeamsModule
{
    public interface IAuditorTeamsService : IService
    {
        Task<List<AuditorTeamsDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<AuditorTeamsDto?> GetByTeamIdAsync(long teamId, CancellationToken cancellationToken);
        public Task<AuditorTeamsPageDto> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
