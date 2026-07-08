using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.Dashboard;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPerfomanceGovernanceSystemRepository : IRepository<PerfomanceGovernanceSystem, long>
    {
        Task<PerfomanceGovernanceSystem?> GetByUserIdAndPgsIdAsync(int pgsId, CancellationToken cancellationToken);
        Task<IEnumerable<PerfomanceGovernanceSystem>> GetAll(CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystem?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystem?> ReportGetByIdAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<PerfomanceGovernanceSystem>> GetByUserIdAsync(string userid, CancellationToken cancellationToken);
        Task<IEnumerable<PerfomanceGovernanceSystem>> GetAllAsyncFilterByPgsPeriod(long? pgsPeriodId, CancellationToken cancellationToken);
        Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedPgsPeriodIdAsync(long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken);
        Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetFilteredPGSAsync(PgsFilter filter, string userId, CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystem?> GetWithIncludesAsync(int id, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystem>> GetByOfficeIdsAsync(List<int> officeIds, CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystem?> GetByIdForSoftDeleteAsync(int deliverableId, CancellationToken cancellationToken);
        Task<List<PgsSignatoryTemplate>> GetTemplatesByServiceHeadAsync(string userId, CancellationToken cancellationToken);
        Task<IEnumerable<PerfomanceGovernanceSystem>> GetByUserOfficeOnlyAsync(string userid, CancellationToken cancellationToken);
        Task<bool> ExistsByOfficeAndPgsPeriodAsync(int officeId, int pgsPeriodId, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystem>> GetOperationReviewProtocolAuditorPgsDeliverableAsync(long? officeId, long? pgsPeriodId, CancellationToken cancellationToken);  
        Task<List<PerfomanceGovernanceSystem>>GetAllOperationReviewProtocolAuditorPgsDeliverableAsync(long? officeId, long? pgsPeriodId, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystem>>GetOperationReviewProtocolAuditorPgsDeliverableByUserAsync(string userId, long? officeId, long? pgsPeriodId, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystem>> GetOperationReviewProtocolAuditorPgsDeliverableByStandardUserAsync(string userId, long? pgsPeriodId,  CancellationToken cancellationToken);
        Task<List<AuditorPendingAuditDto>> GetPendingAuditsByAuditorAsync(long? auditorId, long? teamId, long? officeId, long? parentOfficeId, int? month, int? year, CancellationToken cancellationToken);
        Task<List<ServiceGroupedAuditDto>> GetPendingAuditsByAuditorSortByServiceAsync(long? auditorId, long? teamId, long? officeId, long? parentOfficeId, int? month, int? year, CancellationToken cancellationToken);
        Task<TotalDashboardDeliverableDto> GetTotalDeliverableAsync(List<int> officeIds, int? pgsPeriodId, CancellationToken cancellationToken);
        Task<TotalDashboardOfficeDto> GetTotalOfficeAsync(List<int> officeIds, int? pgsPeriodId, CancellationToken cancellationToken);
        Task<TotalDashboardAuditedDto> GetTotalAuditedAsync(List<int> officeIds, int? pgsPeriodId, CancellationToken cancellationToken);
        Task<DashboardAuditStatusDto> GetDashboardAuditStatusAsync(List<int> officeIds, int? pgsPeriodId, CancellationToken cancellationToken);
        Task<List<int>> GetAllOfficeIdsAsync(CancellationToken cancellationToken);
    }
}
