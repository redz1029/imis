using System;
using Base.Abstractions;

namespace IMIS.Application.PgsModule
{
    public interface IPGSService : IService
    {
        Task<List<PgsDto>?> GetAllAsync(CancellationToken cancellationToken);        
        Task<List<PgsDto>?> GetAllActiveAsync(CancellationToken cancellationToken);

        Task<PgsDto> CreateAsync(PgsDto pgsDto, CancellationToken cancellationToken);
    }
}






