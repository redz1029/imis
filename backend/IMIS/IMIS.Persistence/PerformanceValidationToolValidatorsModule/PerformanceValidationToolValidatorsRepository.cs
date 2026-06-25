using Base.Abstractions;
using IMIS.Application.PerformanceValidationToolValidatorsModule;
using IMIS.Domain;

namespace IMIS.Persistence.PerformanceValidationToolValidatorsModule
{
    public class PerformanceValidationToolValidatorsRepository : BaseRepository<PerformanceValidationToolValidators, long, ImisDbContext, User>, IPerformanceValidationToolValidatorsRepository
    {
        public PerformanceValidationToolValidatorsRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
    }
}
