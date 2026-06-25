using Base.Abstractions;
using IMIS.Application.PerformanceValidationToolDeliverableFindingsModule;
using IMIS.Domain;

namespace IMIS.Persistence.PerformanceValidationToolDeliverableFindingsModule
{
    public class PerformanceValidationToolDeliverableFindingsRepository : BaseRepository<PerformanceValidationToolDeliverableFindings, long, ImisDbContext, User>, IPerformanceValidationToolDeliverableFindingsRepository
    {
        public PerformanceValidationToolDeliverableFindingsRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
    }
}
