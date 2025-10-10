using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleDetailRepository : IRepository<AuditScheduleDetails, int>
    {
        Task<AuditScheduleDetails?> GetOverlappingAuditAsync(int officeId, DateTime startDate, DateTime endDate, int currentAuditId);
        Task<AuditScheduleDetails?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
