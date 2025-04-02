using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleDetailRepository : IRepository<AuditScheduleDetails, int>
    {
        new Task<AuditScheduleDetails> SaveOrUpdateAsync(AuditScheduleDetails auditScheduleDetails, CancellationToken cancellationToken);
    }
}
