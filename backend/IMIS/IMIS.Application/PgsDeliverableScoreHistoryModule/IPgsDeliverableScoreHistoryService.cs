using Base.Abstractions;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableScoreHistoryModule
{
    public interface IPgsDeliverableScoreHistoryService : IService
    {
        Task<PgsDeliverableScoreHistoryDto> SaveOrUpdateAsync(PgsDeliverableScoreHistoryDto pgsDeliverableScoreHistoryDto, CancellationToken cancellationToken);       
    }
}
