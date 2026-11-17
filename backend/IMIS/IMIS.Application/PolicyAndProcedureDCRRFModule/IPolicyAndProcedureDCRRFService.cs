using Base.Abstractions;

namespace IMIS.Application.PolicyAndProcedureDCRRFModule
{
    public interface IPolicyAndProcedureDCRRFService : IService
    {
        Task<PolicyAndProcedureDCRRFDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
    }
}
