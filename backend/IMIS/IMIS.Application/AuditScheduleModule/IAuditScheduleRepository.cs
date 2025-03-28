using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleRepository : IRepository<AuditSchedule, int>
    {
        new Task<AuditSchedule> SaveOrUpdateAsync(AuditSchedule AuditSchedule, CancellationToken cancellationToken);
        Task<IEnumerable<AuditSchedule>> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditSchedule>> GetAllActiveAsync(CancellationToken cancellationToken);
        Task AddAuditableOfficesAsync(List<AuditableOffices> auditableOffices, CancellationToken cancellationToken);       
    }
}
