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

        public async Task<StrategyReview?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<StrategyReview>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<List<StrategyReview>> GetAll(CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<StrategyReview>()
                .Include(x => x.StrategyReviewPeriod)
                .Include(x => x.KraRoadMap)
                    .ThenInclude(x => x!.Kra)
                .Include(x => x.StrategyReviewDeliverable)
                .Include(x => x.StrategyReviewDeliverableKpi)
                .ToListAsync(cancellationToken);
        }

        public async Task<List<StrategyReview>> GetAllForRoleAsync(string roleId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<StrategyReview>()
                .Include(x => x.StrategyReviewPeriod)
                .Include(x => x.KraRoadMap)
                    .ThenInclude(x => x!.Kra)
                .Include(x => x.StrategyReviewDeliverable)
                .Include(x => x.StrategyReviewDeliverableKpi)
                .Where(x => x.RoleId == roleId)
                .OrderBy(x => x.PostingDate)
                .ToListAsync(cancellationToken);
        }

        public async Task<StrategyReview?> GetByIdWithChildrenAsync(long id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<StrategyReview>()
                .AsNoTracking()
                .Include(x => x.StrategyReviewDeliverableKpi)
                .Include(x => x.StrategyReviewDeliverable)
                 .Include(x => x.StrategyReviewPeriod)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }
    
        public async Task<List<string>> GetOfficeNamesByKraIdAsync(long kraId, DateOnly reviewStartDate, DateOnly reviewEndDate, CancellationToken cancellationToken)
        {
            var db = GetDbContext();

            var matchingPeriodId = await db.Set<PgsPeriod>()
                .Where(p => p.StartDate <= reviewEndDate && p.EndDate >= reviewStartDate)
                .Select(p => (int?)p.Id)
                .FirstOrDefaultAsync(cancellationToken);

            if (matchingPeriodId == null)
                return new List<string>();

            var offices = await (
                from d in db.Set<PgsDeliverable>()
                join pgs in db.Set<PerfomanceGovernanceSystem>()
                    on d.PerfomanceGovernanceSystemId equals pgs.Id
                join o in db.Set<Office>()
                    on pgs.OfficeId equals o.Id
                where d.KraId == kraId
                      && d.IsDirect == true
                      && d.IsDeleted == false
                      && pgs.PgsPeriod.Id == matchingPeriodId
                select o.Name
            )
            .Distinct()
            .ToListAsync(cancellationToken);

            return offices;
        }
    }
}
