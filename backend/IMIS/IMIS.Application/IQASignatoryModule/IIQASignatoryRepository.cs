using Base.Abstractions;

namespace IMIS.Application.IQASignatoryModule
{
    public interface IIQASignatoryRepository : IRepository<IMIS.Domain.IQASignatory, long>
    {
        Task<IEnumerable<IMIS.Domain.IQASignatory>> GetByAuditProgrammeIdAsync(int auditProgrammeId, CancellationToken cancellationToken);
        Task<IEnumerable<IMIS.Domain.IQASignatory>> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken);
        Task<IEnumerable<IMIS.Domain.IQASignatory>> GetByAuditScheduleIdAsync(int auditScheduleId, CancellationToken cancellationToken);
        Task<IEnumerable<IMIS.Domain.IQASignatory>> GetBySignatoryIdAsync(string signatoryId, CancellationToken cancellationToken);
    }
}
