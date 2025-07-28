using Base.Abstractions;

namespace IMIS.Application.PgsDeliverableScoreHistoryModule
{
    public interface IPgsDeliverableScoreHistoryService : IService
    {
        Task<PgsDeliverableScoreHistoryDto> SaveOrUpdateAsync(PgsDeliverableScoreHistoryDto pgsDeliverableScoreHistoryDto, CancellationToken cancellationToken);
        Task<List<PgsDeliverableScoreHistoryDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<PgsDeliverableScoreHistoryGroupDto>> GetGroupedScoreHistoryAsync();
    }
}
