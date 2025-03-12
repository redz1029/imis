using Base.Abstractions;

namespace IMIS.Application.OfficeModule
{
    public interface IOfficeService : IService
    {
        Task<List<OfficeDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<OfficeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<OfficeDto>?> GetAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken);
        Task<List<OfficeDto>?> GetNonAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken);
        Task<List<OfficeDto>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
    }
}
