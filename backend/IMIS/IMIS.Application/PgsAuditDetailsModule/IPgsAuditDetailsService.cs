
using Base.Abstractions;

namespace IMIS.Application.PgsModule
{
    public interface IPgsAuditDetailsService : IService
    {
       
        Task<PgsAuditDetailsDto> SaveOrUpdateAsync(PgsAuditDetailsDto PgsDto, CancellationToken cancellationToken);
    }

   
}

