using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IsoStandardAuditPlanModule
{
    public interface IIsoStandardAuditPlanService : IService
    {
        Task<List<IsoStandardAuditPlanDto>?> GetAll(CancellationToken cancellationToken);

        Task<IsoStandardAuditPlanDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        public Task<DtoPageList<IsoStandardAuditPlanDto, IsoStandardAuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}