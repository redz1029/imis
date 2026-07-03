using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.Dashboard;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPerfomanceGovernanceSystemService : IService
    {
        Task<PerfomanceGovernanceSystemDto?> GetByUserIdAndPgsIdAsync(string userId, int pgsId, CancellationToken cancellationToken);
        Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystemDto> SaveOrUpdateAsync(PerfomanceGovernanceSystemDto perfomanceGovernanceSystemDto, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystemDto>?> GetAllAsync(CancellationToken cancellationToken); 
        Task<PerfomanceGovernanceSystemDto?> GetByIdAsync(int id, CancellationToken cancellationToken);    
        Task<ReportPerfomanceGovernanceSystemDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystemDto>> GetByUserIdAsync(string userId, string roleId, int page, int pageSize, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystemDto>> GetAllAsyncFilterByPgsPeriod(long? pgsPeriodId, CancellationToken cancellationToken);               
        Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetPaginatedPgsPeriodIdAsync(long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken);   
        Task<PerfomanceGovernanceSystemDto> Submit(PerfomanceGovernanceSystemDto pgs, string userId, CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystemDto> Draft(PerfomanceGovernanceSystemDto pgs, string userId, CancellationToken cancellationToken);
        Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetFilteredPGSAsync(PgsFilter filter, string userId, string roleid, CancellationToken cancellationToken);
        Task<bool> SoftDeleteDeliverableAsync(int deliverableId, CancellationToken cancellationToken);
        Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>>GetAuditorPgsDeliverableAsync(string roleId, long? officeId, long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken);
        Task<List<AuditorPendingAuditDto>> GetPendingAuditsByAuditorAsync(long? auditorId, long? teamId, long? officeId, int? month, int? year, CancellationToken cancellationToken);
        Task<List<AuditorPendingAuditDto>> ReportGetPendingAuditsByAuditorAsync(long? auditorId, long? teamId, long? officeId, int? month, int? year, CancellationToken cancellationToken);     
        Task<TotalDashboardDeliverableDto> GetTotalDeliverableAsync(int? pgsPeriodId, CancellationToken cancellationToken);
        Task<TotalDashboardOfficeDto> GetTotalOfficeAsync(int? pgsPeriodId, CancellationToken cancellationToken);
        Task<TotalDashboardAuditedDto> GetTotalAuditedAsync(int? pgsPeriodId, CancellationToken cancellationToken);
    }
}
