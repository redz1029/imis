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
        Task<PolicyAndProcedureDto> SubmitAsync(PolicyAndProcedureDto dto, string userId, CancellationToken cancellationToken);
        Task<PolicyAndProcedureDto> DraftAsync(PolicyAndProcedureDto dto, string userId, CancellationToken cancellationToken);
        Task<DtoPageList<PolicyAndProcedureDto, PolicyAndProcedure, long>> GetFilteredAsync(PolicyAndProcedureFilter filter, string roleId, CancellationToken cancellationToken);
    }
}
 