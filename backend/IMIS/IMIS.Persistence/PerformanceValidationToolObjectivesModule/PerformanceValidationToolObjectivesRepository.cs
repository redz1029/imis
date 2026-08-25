using Base.Abstractions;
using IMIS.Application.PerformanceValidationToolObjectivesModule;
using IMIS.Domain;

namespace IMIS.Persistence.PerformanceValidationToolObjectivesModule
{
    public class PerformanceValidationToolObjectivesRepository : BaseRepository<PerformanceValidationToolObjectives, long, ImisDbContext, User>, IPerformanceValidationToolObjectivesRepository
    {
        public PerformanceValidationToolObjectivesRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
    }
}
