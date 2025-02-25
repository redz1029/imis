using Base.Abstractions;
using IMIS.Application.PgsKraModule;


namespace IMIS.Application.PgsModule
{
    public interface IPGSDeliverableService : IService
    {
        Task<List<PGSDeliverableDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PGSDeliverableDto> SaveOrUpdateAsync(PGSDeliverableDto pgsDto, CancellationToken cancellationToken);
    }
}






