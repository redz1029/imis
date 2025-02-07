using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Base.Abstractions;
using IMIS.Application.PgsModule;

namespace IMIS.Application.PgsKraModule
{
    public interface IKraService : IService
    {
        Task<KraDto> SaveOrUpdateAsync(KraDto KraDto, CancellationToken cancellationToken);
        
    }


   
}
