using Base.Abstractions;
using IMIS.Application.PgsKraModule;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleService : IService
    {
        Task<AuditScheduleDto> SaveOrUpdateAsync(AuditScheduleDto AuditSchedule, CancellationToken cancellationToken);
        Task<List<AuditScheduleDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<AuditScheduleDto>?> GetAllActiveAsync(CancellationToken cancellationToken);
        Task<AuditScheduleDto?> GenerateAuditScheduleDetail(int auditScheduleId, double noOfHoursPerAudit, CancellationToken cancellationToken);
    }
}
