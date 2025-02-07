using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPgsAuditDetailsRepository : IRepository<PgsAuditDetails, long>
    {
        new Task<PgsAuditDetails> SaveOrUpdateAsync(PgsAuditDetails PgsProjectStatus, CancellationToken cancellationToken);

    }

  
}
