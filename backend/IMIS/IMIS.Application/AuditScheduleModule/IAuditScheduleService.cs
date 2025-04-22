using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditableOfficesModule;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleService : IService
    {
        Task<AuditScheduleDto> SaveOrUpdateAsync(AuditScheduleDto auditSchedule, CancellationToken cancellationToken);
        Task<List<AuditScheduleDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<AuditScheduleDto>?> GetAllActiveAsync(CancellationToken cancellationToken);
        Task<AuditScheduleDto?> GenerateAuditScheduleDetail(int auditScheduleId, double noOfHoursPerAudit, CancellationToken cancellationToken);
        Task SaveAuditableOfficesAsync(List<AuditableOfficesDto> auditableOfficesList, CancellationToken cancellationToken);
        Task<List<string>> GetOverlappingAuditAsync(AuditScheduleDto auditScheduleDto, CancellationToken cancellationToken);
        Task<AuditScheduleDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<AuditScheduleDto, AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
