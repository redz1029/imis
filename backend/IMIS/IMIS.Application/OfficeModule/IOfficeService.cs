using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.OfficeModule
{
    public interface IOfficeService : IService
    {
        public Task<DtoPageList<OfficeDto, Office, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<OfficeDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<OfficeDto>> GetOfficesForPgsAuditorAsync(CancellationToken cancellationToken);
        Task<OfficeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<OfficeDto>?> GetAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken);
        Task<List<OfficeDto>?> GetNonAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken);
        Task<List<OfficeDto>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
        Task<bool> HasCircularReferenceAsync(int? parentId, int childId, CancellationToken cancellationToken);
        Task<OfficeDto> GetRootParentOfficeAsync(int officeId, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
