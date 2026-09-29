using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NcarMonitoringLogModule
{
    public interface INcarMonitoringLogService : IService
    {
        Task<NcarMonitoringLogDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<DtoPageList<NcarMonitoringLogDto, NcarMonitoringLog, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(long id, CancellationToken cancellationToken);

        // Auto create/update monitoring log entry when an NCAR is issued/saved.
        Task<NcarMonitoringLogDto> SyncFromNcarAsync(long nonconformingActionReportId, string deptSectionUnit, DateTime dateIssued,
            string issuedByName, string itemNoRelevantStandard, string auditeeName, CancellationToken cancellationToken);

        Task<bool> UpdateVerificationAsync(long id, DateTime dateVerified, string verifiedByAuditorName, CancellationToken cancellationToken);
        Task<bool> UpdateValidationAsync(long id, DateTime dateValidated, CancellationToken cancellationToken);
    }
}
