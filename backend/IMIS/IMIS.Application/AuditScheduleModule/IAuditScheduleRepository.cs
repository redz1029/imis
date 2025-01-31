using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleRepository : IRepository<AuditSchedule, int>
    {
        Task<IEnumerable<AuditSchedule>> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditSchedule>> GetAllActiveAsync(CancellationToken cancellationToken);
    }
}
