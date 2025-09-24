using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Application.OfficeTypeModule
{
    public interface IOfficeTypeService : IService
    {
        Task<List<OfficeTypeDto>?> GetAllAsync(CancellationToken cancellationToken);
        public Task<DtoPageList<OfficeTypeDto, OfficeType, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
