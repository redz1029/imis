using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IsoAuditProcessModule
{
    public interface IIsoAuditProcessService : IService
    {
        Task<List<IsoAuditProcessDto>?> GetAll(CancellationToken cancellationToken);

        Task<IsoAuditProcessDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        Task<DtoPageList<IsoAuditProcessDto, IsoAuditProcess, int>> GetPaginatedAsync( int page,int pageSize,CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}