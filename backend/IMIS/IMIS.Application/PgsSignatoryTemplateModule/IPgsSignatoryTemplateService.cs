using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryTemplateModule
{
    public interface IPgsSignatoryTemplateService : IService
    {
        Task<List<PgsSignatoryTemplateDto>> SaveOrUpdateAsync(List<PgsSignatoryTemplateDto> templates, CancellationToken cancellationToken);
        Task<List<PgsSignatoryTemplateDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PgsSignatoryTemplateDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<DtoPageList<PgsSignatoryTemplateDto, PgsSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<PgsSignatoryTemplateDto>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
