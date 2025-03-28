using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IMIS.Application.PgsPeriodModule;

namespace IMIS.Application.AuditableOfficesModule
{
    public interface IAuditableOfficesService
    {
        Task<AuditableOfficesDto> SaveOrUpdateAsync(AuditableOfficesDto AuditableOfficesDto, CancellationToken cancellationToken);
    }
}
