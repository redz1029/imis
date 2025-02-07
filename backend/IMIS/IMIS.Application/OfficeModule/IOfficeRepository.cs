using Base.Abstractions;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMIS.Application.OfficeModule
{
    public interface IOfficeRepository : IRepository<Office, int>
    {
        Task<IEnumerable<Office>> GetAll(CancellationToken cancellationToken);
    
      
    }
}
