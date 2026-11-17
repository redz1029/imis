using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureDCRRFModule
{
    public interface IPolicyAndProcedureDCRRFRepository : IRepository<PolicyAndProcedureDCRRF, long>
    {
        Task<PolicyAndProcedureDCRRF?> GetByIdWithListAsync(long id, CancellationToken cancellationToken);
    }
}
