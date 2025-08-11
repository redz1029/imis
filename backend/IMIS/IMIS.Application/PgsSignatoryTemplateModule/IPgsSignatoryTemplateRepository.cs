using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryTemplateModule
{
    public interface IPgsSignatoryTemplateRepository : IRepository<PgsSignatoryTemplate, int>
    {
        Task<IEnumerable<PgsSignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken);
        Task<EntityPageList<PgsSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<PgsSignatoryTemplate>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken);
    }
}
