using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsPeriodModule
{
    public interface IPgsPeriodRepository : IRepository<PgsPeriod, int>
    {
        new Task<PgsPeriod> SaveOrUpdateAsync(PgsPeriod period, CancellationToken cancellationToken);
    }
}
