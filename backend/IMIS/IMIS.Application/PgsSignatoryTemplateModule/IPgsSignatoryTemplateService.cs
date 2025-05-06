using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryTemplateModule
{
    public interface IPgsSignatoryTemplateService : IService
    {       
        Task<PgsSignatoryTemplateDto> SaveOrUpdateAsync(PgsSignatoryTemplateDto pgsSignatoryTemplateDto, CancellationToken cancellationToken);
        Task<List<PgsSignatoryTemplateDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PgsSignatoryTemplateDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<PgsSignatoryTemplateDto, PgsSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
