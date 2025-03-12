using Base.Abstractions;
using IMIS.Application.UserOfficeModule;

namespace IMIS.Application.PgsModule
{
    public interface IPGSDeliverableService : IService
    {

        Task<PGSDeliverableDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<PGSDeliverableDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PGSDeliverableDto> SaveOrUpdateAsync(PGSDeliverableDto pgsDto, CancellationToken cancellationToken);
    }
}






