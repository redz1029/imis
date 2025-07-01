using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryTemplateModule
{
    public interface IPgsSignatoryTemplateRepository : IRepository<PgsSignatoryTemplate, int>
    {
        new Task<PgsSignatoryTemplate> SaveOrUpdateAsync(PgsSignatoryTemplate pgsSignatoryTemplate, CancellationToken cancellationToken);      
        Task<IEnumerable<PgsSignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken);
        Task<EntityPageList<PgsSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
