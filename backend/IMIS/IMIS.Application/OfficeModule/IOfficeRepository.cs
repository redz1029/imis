using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.OfficeModule
{
    public interface IOfficeRepository : IRepository<Office, int>
    {
        Task<IEnumerable<Office>> GetAll(CancellationToken cancellationToken);
        Task<IEnumerable<Office>?> GetAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken);
        Task<IEnumerable<Office>?> GetNonAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken);
    }
}
