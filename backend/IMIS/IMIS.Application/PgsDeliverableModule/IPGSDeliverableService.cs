using System;
using Base.Abstractions;

namespace IMIS.Application.PgsModule
{
    public interface IPGSDeliverableService : IService
    {
       

        Task<PGSDeliverableDto> SaveOrUpdateAsync(PGSDeliverableDto pgsDto, CancellationToken cancellationToken);
    }
}






