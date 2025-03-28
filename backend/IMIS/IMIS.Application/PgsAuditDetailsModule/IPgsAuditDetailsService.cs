using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;
using static IMIS.Application.PgsModule.PgsAuditDetailsDto;

namespace IMIS.Application.PgsModule
{
    public interface IPgsAuditDetailsService : IService
    {
        public Task<DtoPageList<PgsAuditDetailsDto, PgsAuditDetails, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PgsAuditDetailsDto> SaveOrUpdateAsync(PgsAuditDetailsDto pgsDto, CancellationToken cancellationToken);
        Task<List<PgsAuditDetailsDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PgsAuditDetailsDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
    }
}
