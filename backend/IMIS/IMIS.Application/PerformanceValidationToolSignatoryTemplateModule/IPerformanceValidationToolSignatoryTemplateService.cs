using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolSignatoryTemplateModule
{
    public interface IPerformanceValidationToolSignatoryTemplateService : IService
    {
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<DtoPageList<PerformanceValidationToolSignatoryTemplateDto, PerformanceValidationToolSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PerformanceValidationToolSignatoryTemplateDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<PerformanceValidationToolSignatoryTemplateDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<PerformanceValidationToolSignatoryTemplateDto>> SaveOrUpdateAsync(List<PerformanceValidationToolSignatoryTemplateDto> templates, CancellationToken cancellationToken);
    }
}
