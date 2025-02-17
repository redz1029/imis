using Base.Abstractions;

namespace IMIS.Application.PgsPeriodModule
{
    public interface IPgsPeriodService : IService
    {        
        Task<List<PgsPeriodDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PgsPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<PgsPeriodDto> SaveOrUpdateAsync(PgsPeriodDto periodDto, CancellationToken cancellationToken);
    }
}
