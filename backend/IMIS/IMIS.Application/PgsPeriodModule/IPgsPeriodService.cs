using Base.Abstractions;

namespace IMIS.Application.PgsPeriodModule
{
    public interface IPgsPeriodService : IService
    {
        Task<PgsPeriodDto> SaveOrUpdateAsync(PgsPeriodDto PeriodDto, CancellationToken cancellationToken);
    } 
}
