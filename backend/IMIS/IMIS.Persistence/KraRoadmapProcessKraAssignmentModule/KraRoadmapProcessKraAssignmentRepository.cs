using Base.Abstractions;
using IMIS.Application.KraRoadmapCoreSupportProcessModule;
using IMIS.Application.KraRoadmapProcessKraAssignmentModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraRoadmapProcessKraAssignmentModule
{
    public class KraRoadmapProcessKraAssignmentRepository : BaseRepository<KraRoadmapProcessKraAssignment, int, ImisDbContext, User>, IKraRoadmapProcessKraAssignmentRepository
    {
        public KraRoadmapProcessKraAssignmentRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
    }
}
