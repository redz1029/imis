using Base.Abstractions;
using IMIS.Application.PerformanceValidationToolConclusionModule;
using IMIS.Domain;

namespace IMIS.Persistence.PerformanceValidationToolConclusionModule
{
    public class PerformanceValidationToolConclusionRepository : BaseRepository<PerformanceValidationToolConclusion, long, ImisDbContext, User>, IPerformanceValidationToolConclusionRepository
    {
        public PerformanceValidationToolConclusionRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
    }
}
