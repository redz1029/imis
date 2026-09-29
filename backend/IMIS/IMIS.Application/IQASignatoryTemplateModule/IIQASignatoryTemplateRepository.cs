using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IQASignatoryTemplateModule
{
    public interface IIQASignatoryTemplateRepository : IRepository<IQASignatoryTemplate, int>
    {
        Task<IQASignatoryTemplate?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);

        Task<IEnumerable<IQASignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken);

        Task<IEnumerable<IQASignatoryTemplate>> GetByAuditEntityTypeAsync(string auditEntityType, CancellationToken cancellationToken);

        Task<IEnumerable<IQASignatoryTemplate>> GetByOfficeIdAsync(int officeId, CancellationToken cancellationToken);

        Task<IEnumerable<IQASignatoryTemplate>> GetByStatusAsync(string status, CancellationToken cancellationToken);

        Task<EntityPageList<IQASignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<IQASignatoryTemplate?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
    }
}