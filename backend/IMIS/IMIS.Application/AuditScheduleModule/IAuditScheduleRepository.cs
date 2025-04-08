using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleRepository : IRepository<AuditSchedule, int>
    {
        new Task<AuditSchedule> SaveOrUpdateAsync(AuditSchedule auditSchedule, CancellationToken cancellationToken);
        Task<IEnumerable<AuditSchedule>> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditSchedule>> GetAllActiveAsync(CancellationToken cancellationToken);
        Task AddAuditableOfficesAsync(List<AuditableOffices> auditableOffices, CancellationToken cancellationToken);       
        Task<AuditScheduleDetails?> GetOverlappingAuditAsync(int officeId, DateTime startDateTime, DateTime endDateTime, int id);

    }
}
