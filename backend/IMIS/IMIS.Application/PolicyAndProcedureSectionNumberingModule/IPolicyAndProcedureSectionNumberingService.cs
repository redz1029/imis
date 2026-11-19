using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureSectionNumberingModule
{
    public interface IPolicyAndProcedureSectionNumberingService : IService
    {
        Task<PolicyAndProcedureSectionNumberingDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<PolicyAndProcedureSectionNumberingDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<PolicyAndProcedureSectionNumberingDto, PolicyAndProcedureSectionNumbering, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
