using Base.Abstractions;
using IMIS.Application.PolicyAndProcedureHistoryLogModule;

namespace IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionModule
{
    public interface IPolicyAndProcedureOfficeDocumentDistributionService : IService
    {
        Task<PolicyAndProcedureOfficeDocumentDistributionDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<PolicyAndProcedureOfficeDocumentDistributionDto> SaveOrUpdateAsync(PolicyAndProcedureOfficeDocumentDistributionDto dto, CancellationToken cancellationToken);
    }
}
