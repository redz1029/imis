using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PerformanceValidationToolSignatoryTemplateModule;
using IMIS.Domain;

namespace IMIS.Application.ISATSignatoryTemplateModule
{
    public interface IISATSignatoryTemplateService : IService
    {
        Task<List<ISATSignatoryTemplateDto>> SaveOrUpdateAsync(List<ISATSignatoryTemplateDto> templates, CancellationToken cancellationToken);
        Task<List<ISATSignatoryTemplateDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<ISATSignatoryTemplateDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<DtoPageList<ISATSignatoryTemplateDto, ISATSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
