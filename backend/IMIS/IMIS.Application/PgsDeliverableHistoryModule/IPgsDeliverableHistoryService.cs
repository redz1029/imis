using Base.Abstractions;

namespace IMIS.Application.PgsDeliverableHistoryModule
{
    public interface IPgsDeliverableHistoryService : IService
    {
        Task<PgsDeliverableHistoryDto> SaveOrUpdateAsync(PgsDeliverableHistoryDto pgsDeliverableHistoryDto, CancellationToken cancellationToken);
    }
}
