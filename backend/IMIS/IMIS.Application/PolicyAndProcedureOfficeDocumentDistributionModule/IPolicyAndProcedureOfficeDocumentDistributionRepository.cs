using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionModule
{
    public interface IPolicyAndProcedureOfficeDocumentDistributionRepository : IRepository<PolicyAndProcedureOfficeDocumentDistribution, long>
    {
        Task<PolicyAndProcedureOfficeDocumentDistribution?> GetByIdWithListAsync(long id, CancellationToken cancellationToken);
    }
}
