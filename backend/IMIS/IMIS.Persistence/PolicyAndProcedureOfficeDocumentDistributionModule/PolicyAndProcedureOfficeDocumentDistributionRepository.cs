using Base.Abstractions;
using IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionModule;
using IMIS.Domain;

namespace IMIS.Persistence.PolicyAndProcedureOfficeDocumentDistributionModule
{
    public class PolicyAndProcedureOfficeDocumentDistributionRepository : BaseRepository<PolicyAndProcedureOfficeDocumentDistribution, long, ImisDbContext, User>, IPolicyAndProcedureOfficeDocumentDistributionRepository
    {
        public PolicyAndProcedureOfficeDocumentDistributionRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
    }

}
