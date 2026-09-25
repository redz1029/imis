using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ISATModule
{
    public interface IISATService : IService
    {
        Task<List<PgsDeliverableListDto>> GetPgsDeliverablesByOfficeAndPeriodAsync(int officeId, int periodId, CancellationToken cancellationToken);
        Task<List<KraRoadMapDeliverableListDto>> GetDeliverablesByRoadMapIdAndYearAsync(long roadMapId, int year, CancellationToken cancellationToken);
        Task<List<KraRoadMapListDto>> GetRoadMapListAsync(CancellationToken cancellationToken);
        Task<ISATDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<ISATEmployeeProfileDto?> GetEmployeeProfileByUserIdAsync(string userid, CancellationToken cancellationToken);
        Task<DtoPageList<ISATDto, ISAT, long>?> GetPaginatedByUserIdAsync(string userId, string roleId, int? officeId, int page, int pageSize, CancellationToken cancellationToken);
        Task<ISATDto> Submit(ISATDto dto, string userId, CancellationToken cancellationToken);
    }
}
