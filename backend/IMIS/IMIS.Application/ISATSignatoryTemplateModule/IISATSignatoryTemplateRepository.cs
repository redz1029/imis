using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ISATSignatoryTemplateModule
{
    public interface IISATSignatoryTemplateRepository : IRepository<ISATSignatoryTemplate, int>
    {
        Task<List<ISATSignatoryTemplate>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken);
        Task<IEnumerable<ISATSignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken);
        Task<EntityPageList<ISATSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<ISATSignatoryTemplate?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
