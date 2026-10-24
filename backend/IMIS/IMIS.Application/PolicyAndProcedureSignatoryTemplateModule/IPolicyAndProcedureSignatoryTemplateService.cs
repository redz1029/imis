using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureSignatoryTemplateModule
{
    public interface IPolicyAndProcedureSignatoryTemplateService : IService
    {
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<List<PolicyAndProcedureSignatoryTemplateDto>> SaveOrUpdateAsync(List<PolicyAndProcedureSignatoryTemplateDto> templates, CancellationToken cancellationToken);
        Task<List<PolicyAndProcedureSignatoryTemplateDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PolicyAndProcedureSignatoryTemplateDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<DtoPageList<PolicyAndProcedureSignatoryTemplateDto, PolicyAndProcedureSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
