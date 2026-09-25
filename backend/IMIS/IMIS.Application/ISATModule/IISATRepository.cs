using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ISATModule
{
    public interface IISATRepository : IRepository<ISAT, long>
    {
        Task<List<KraRoadMapDeliverableListDto>> GetDeliverablesByRoadMapIdAndYearAsync(long roadMapId, int year, CancellationToken cancellationToken);
        Task<ISAT?> GetByIsatIdAsync(long id, CancellationToken cancellationToken);
        Task<UserOffices?> GetActiveUserOfficeAsync(string userId, CancellationToken cancellationToken);
        Task<Office?> GetOfficeWithParentAsync(int officeId, CancellationToken cancellationToken);
        Task<UserOffices?> GetOfficeHeadAsync(int officeId, CancellationToken cancellationToken);
        Task<EntityPageList<ISAT, long>> GetPaginatedAllAsync(int? officeId, int page, int pageSize, CancellationToken cancellationToken);
        Task<EntityPageList<ISAT, long>> GetPaginatedByUserIdAsync(string userId, int? officeId, int page, int pageSize, CancellationToken cancellationToken);
        Task<List<KraRoadMapListDto>> GetRoadMapListAsync(CancellationToken cancellationToken);
        Task<List<PgsDeliverableListDto>> GetPgsDeliverablesByOfficeAndPeriodAsync(int officeId, int periodId, CancellationToken cancellationToken);
        Task<ISAT?> GetWithIncludesAsync(long id, CancellationToken cancellationToken);
        Task<List<ISAT>> GetCandidatesForUserAsync(string userId, int? officeId, CancellationToken cancellationToken);
    }
}
