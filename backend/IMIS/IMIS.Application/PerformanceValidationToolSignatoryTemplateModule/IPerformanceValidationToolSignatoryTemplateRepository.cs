using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolSignatoryTemplateModule
{
    public interface IPerformanceValidationToolSignatoryTemplateRepository : IRepository<PerformanceValidationToolSignatoryTemplate, int>
    {
        Task<PerformanceValidationToolSignatoryTemplate?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<PerformanceValidationToolSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<PerformanceValidationToolSignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken);
        Task<List<PerformanceValidationToolSignatoryTemplate>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken);
    }
}
