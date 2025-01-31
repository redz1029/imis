using Base.Abstractions;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditorScheduleService : IService
    {
        Task<List<AuditScheduleDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<AuditScheduleDto>?> GetAllActiveAsync(CancellationToken cancellationToken);
        Task<AuditScheduleDto?> GenerateAuditScheduleDetail(int auditScheduleId, double noOfHoursPerAudit, CancellationToken cancellationToken);
    }
}
