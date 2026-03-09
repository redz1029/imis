using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanPersonResponsibleModule
{
    public interface IAuditPlanPersonResponsibleService : IService
    {
        Task<DtoPageList<AuditPlanPersonResponsibleDto, AuditPlanPersonResponsible, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<AuditPlanPersonResponsibleDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<AuditPlanPersonResponsibleDto>?> GetActiveAsync(CancellationToken cancellationToken);
        Task<AuditPlanPersonResponsibleDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<AuditPlanPersonResponsibleDto>?> SearchByNameAsync(string name, CancellationToken cancellationToken);
        Task<AuditPlanPersonResponsibleDto?> GetByNameAsync(string name, CancellationToken cancellationToken);
        Task<List<AuditPlanPersonResponsibleDto>?> GetByPositionAsync(string position, CancellationToken cancellationToken);
        Task<AuditPlanPersonResponsibleDto> CreateAsync(AuditPlanPersonResponsibleDto personDto, CancellationToken cancellationToken);
        Task<AuditPlanPersonResponsibleDto> UpdateAsync(AuditPlanPersonResponsibleDto personDto, CancellationToken cancellationToken);

        // Updated to SoftDelete per your request
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        Task<bool> ActivateAsync(int id, CancellationToken cancellationToken);
        Task<bool> DeactivateAsync(int id, CancellationToken cancellationToken);
        Task<bool> ExistsByNameAsync(string name, int? excludeId = null, CancellationToken cancellationToken = default);
    }
}