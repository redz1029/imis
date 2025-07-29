using Base.Abstractions;
using IMIS.Application.PgsModule;

namespace IMIS.Application.PgsDeliverableHistoryModule
{
    public interface IPgsDeliverableHistoryService : IService
    {
        Task<PgsDeliverableHistoryDto> SaveOrUpdateAsync(PgsDeliverableHistoryDto pgsDeliverableHistoryDto, CancellationToken cancellationToken);
        Task<List<PgsDeliverableHistoryDto>?> GetByIdAsync(int id, CancellationToken cancellationToken);       
    }
}
