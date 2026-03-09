using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanEntryModule
{
    public interface IAuditPlanEntryService : IService
    {
        // READ
        Task<List<AuditPlanEntryDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<AuditPlanEntryDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<DtoPageList<AuditPlanEntryDto, AuditPlanEntry, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // Relationship-Based Queries
        Task<List<AuditPlanEntryDto>?> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken);
        Task<List<AuditPlanEntryDto>?> GetByDayNumberAsync(int auditPlanId, int dayNumber, CancellationToken cancellationToken);
        Task<List<AuditPlanEntryDto>?> GetByOfficeIdAsync(int officeId, CancellationToken cancellationToken);
        Task<List<AuditPlanEntryDto>?> GetByTeamIdAsync(int teamId, CancellationToken cancellationToken);

        // Filtering by related entities
        Task<List<AuditPlanEntryDto>?> GetByAuditorIdAsync(string auditorId, CancellationToken cancellationToken);
        Task<List<AuditPlanEntryDto>?> GetByProcessIdAsync(int processId, CancellationToken cancellationToken);
        Task<List<AuditPlanEntryDto>?> GetByResponsiblePersonIdAsync(int personId, CancellationToken cancellationToken);
        Task<List<AuditPlanEntryDto>?> GetByIsoStandardIdAsync(int standardId, CancellationToken cancellationToken);

        // COMMANDS
        Task<AuditPlanEntryDto> CreateAsync(AuditPlanEntryDto entryDto, CancellationToken cancellationToken);
        Task<AuditPlanEntryDto> UpdateAsync(AuditPlanEntryDto entryDto, CancellationToken cancellationToken);
        Task<List<AuditPlanEntryDto>> CreateMultipleAsync(List<AuditPlanEntryDto> entriesDto, CancellationToken cancellationToken);

        // DELETION
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}