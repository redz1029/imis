using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureModule
{
    public interface IPolicyAndProcedureService : IService
    {
        Task<PolicyAndProcedureDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<PolicyAndProcedureDto, PolicyAndProcedure, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
 