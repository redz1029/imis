using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureSignatoryTemplateModule
{
    public interface IPolicyAndProcedureSignatoryTemplateRepository : IRepository<PolicyAndProcedureSignatoryTemplate, int>
    {
        Task<List<PolicyAndProcedureSignatoryTemplate>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken);
        Task<IEnumerable<PolicyAndProcedureSignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken);
        Task<EntityPageList<PolicyAndProcedureSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PolicyAndProcedureSignatoryTemplate?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
