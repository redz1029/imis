using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanProcessModule
{
    public interface IAuditPlanProcessService : IService
    {
        Task<DtoPageList<AuditPlanProcessDto, AuditPlanProcess, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<AuditPlanProcessDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<AuditPlanProcessDto>?> GetActiveAsync(CancellationToken cancellationToken);
        Task<AuditPlanProcessDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<AuditPlanProcessDto>?> SearchByNameAsync(string name, CancellationToken cancellationToken);
        Task<AuditPlanProcessDto?> GetByNameAsync(string name, CancellationToken cancellationToken);
        Task<AuditPlanProcessDto> CreateAsync(AuditPlanProcessDto processDto, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<bool> ActivateAsync(int id, CancellationToken cancellationToken);
        Task<bool> DeactivateAsync(int id, CancellationToken cancellationToken);
        Task<bool> ExistsByNameAsync(string name, int? excludeId = null, CancellationToken cancellationToken = default);
    }
}