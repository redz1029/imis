using Base.Abstractions;
using static IMIS.Application.PgsModule.PgsAuditDetailsDto;

namespace IMIS.Application.PgsModule
{
    public interface IPgsAuditDetailsService : IService
    {       
        Task<PagedResult<PgsAuditDetailsDto>> GetPagedPgsAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PgsAuditDetailsDto> SaveOrUpdateAsync(PgsAuditDetailsDto pgsDto, CancellationToken cancellationToken);
    }
}
