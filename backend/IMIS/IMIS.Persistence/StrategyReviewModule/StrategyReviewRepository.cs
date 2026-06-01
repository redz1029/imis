using Base.Abstractions;
using IMIS.Application.StrategyReviewModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.StrategyReviewModule
{
    public class StrategyReviewRepository : BaseRepository<StrategyReview, long, ImisDbContext, User>, IStrategyReviewRepository
    {
        public StrategyReviewRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<StrategyReview?> GetByIdWithChildrenAsync(long id,  CancellationToken cancellationToken)
        {            
            return await ReadOnlyDbContext.Set<StrategyReview>()
                .AsNoTracking()
                .Include(x => x.StrategyReviewDeliverableKpi)
                .Include(x => x.StrategyReviewDeliverable)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }
        public async Task<List<string>> GetOfficeNamesByKraRoadMapIdAsync(long kraRoadMapId, CancellationToken cancellationToken)
        {
            var db = GetDbContext();

            var offices = await (
                from krd in db.Set<KraRoadMapDeliverable>()

                join d in db.Set<PgsDeliverable>()
                    on krd.KraDescription equals d.KraDescription

                join pgs in db.Set<PerfomanceGovernanceSystem>()
                    on d.PerfomanceGovernanceSystemId equals pgs.Id

                join o in db.Set<Office>()
                    on pgs.OfficeId equals o.Id

                where krd.KraRoadMapId == kraRoadMapId
                      && d.IsDeleted == false
                      && krd.IsDeleted == false

                select o.Name
            )
            .Distinct()
            .ToListAsync(cancellationToken);

            return offices;
        }

    }
}
