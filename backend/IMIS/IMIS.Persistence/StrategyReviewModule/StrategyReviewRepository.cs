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

        private async Task<int?> GetMatchingPgsPeriodIdAsync(DateOnly startDate, DateOnly endDate, CancellationToken cancellationToken)
        {
            var db = GetDbContext();

            return await db.Set<PgsPeriod>()
                .Where(p => p.StartDate <= endDate && p.EndDate >= startDate)
                .OrderBy(p => p.StartDate)
                .ThenBy(p => p.Id)
                .Select(p => (int?)p.Id)
                .FirstOrDefaultAsync(cancellationToken);
        }

        public async Task<StrategyReviewPeriod?> GetPeriodAsync(int? strategyReviewPeriodId, CancellationToken cancellationToken)
        {
            var query = ReadOnlyDbContext.Set<StrategyReviewPeriod>().AsNoTracking();

            if (strategyReviewPeriodId.HasValue)
                return await query.FirstOrDefaultAsync(p => p.Id == strategyReviewPeriodId.Value, cancellationToken);

            return await query
                .OrderByDescending(p => p.StartDate)
                .FirstOrDefaultAsync(cancellationToken);
        }
   
        public async Task<StrategyReviewOfficeDeliverableDto?> GetOfficeDeliverablesByStrategyReviewIdAsync(long strategyReviewId, CancellationToken cancellationToken)
        {
            var db = GetDbContext();

            var review = await db.Set<StrategyReview>()
                .AsNoTracking()
                .Include(x => x.StrategyReviewPeriod)
                .Include(x => x.KraRoadMap)
                    .ThenInclude(x => x!.Kra)
                .FirstOrDefaultAsync(x => x.Id == strategyReviewId, cancellationToken);

            if (review == null)
                return null;

            var roadmapName = review.KraRoadMap?.Kra?.Name ?? string.Empty;

            if (review.KraRoadMap?.KraId == null || review.StrategyReviewPeriod == null)
                return new StrategyReviewOfficeDeliverableDto { RoadmapName = roadmapName };

            var result = await GetOfficeDeliverablesByKraIdAsync(
                review.KraRoadMap.KraId.Value,
                review.StrategyReviewPeriod.StartDate,
                review.StrategyReviewPeriod.EndDate,
                cancellationToken);

            result.RoadmapName = roadmapName;
            return result;
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

        public async Task<StrategyReviewOfficeDeliverableDto> GetOfficeDeliverablesByKraIdAsync(long kraId, DateOnly startDate, DateOnly endDate, CancellationToken cancellationToken)
        {
            var db = GetDbContext();
            var result = new StrategyReviewOfficeDeliverableDto();

            var matchingPeriodId = await GetMatchingPgsPeriodIdAsync(startDate, endDate, cancellationToken);

            if (matchingPeriodId == null)
                return result;

            var rows = await (
                from d in db.Set<PgsDeliverable>()
                join pgs in db.Set<PerfomanceGovernanceSystem>()
                    on d.PerfomanceGovernanceSystemId equals pgs.Id
                join o in db.Set<Office>()
                    on pgs.OfficeId equals o.Id
                where d.KraId == kraId
                      && d.IsDirect == true
                      && d.IsDeleted == false
                      && pgs.PgsPeriod.Id == matchingPeriodId
                select new
                {
                    OfficeName = o.Name,
                    DeliverableId = d.Id,
                    d.DeliverableName,
                    d.SortOrder
                }
            )
            .Distinct()
            .ToListAsync(cancellationToken);

            var deliverableIds = rows.Select(r => r.DeliverableId).Distinct().ToList();

            var cutoff = endDate.ToDateTime(TimeOnly.MaxValue);

            var latestList = await db.Set<PgsDeliverableAccomplishment>()
                .AsNoTracking()
                .Where(a => deliverableIds.Contains(a.PgsDeliverableId)
                         && !a.IsDeleted
                         && a.PostingDate <= cutoff
                         && (a.PercentAccomplished > 0
                             || !string.IsNullOrEmpty(a.Remarks)
                             || !string.IsNullOrEmpty(a.AttachmentPath)))
                .GroupBy(a => a.PgsDeliverableId)
                .Select(g => g
                    .OrderByDescending(a => a.PostingDate)
                    .ThenByDescending(a => a.Id)
                    .First())
                .ToListAsync(cancellationToken);

            var latestByDeliverable = latestList.ToDictionary(a => a.PgsDeliverableId);

            result.Deliverables = rows
                .GroupBy(x => x.OfficeName)
                .OrderBy(g => g.Key, StringComparer.OrdinalIgnoreCase)
                .Select(g => new StrategyReviewOfficeDeliverableItemDto
                {
                    OfficeName = g.Key,
                    Deliverables = g
                        .OrderBy(x => x.SortOrder)
                        .Where(x => !string.IsNullOrWhiteSpace(x.DeliverableName))
                        .Select(x =>
                        {
                            latestByDeliverable.TryGetValue(x.DeliverableId, out var acc);

                            return new StrategyReviewDeliverableItemDto
                            {
                                PgsDeliverableId = x.DeliverableId,
                                DeliverableName = x.DeliverableName,
                                Accomplishment = acc == null ? null : new StrategyReviewLatestAccomplishmentDto
                                {
                                    PostingDate = acc.PostingDate,
                                    PostingMonth = acc.PostingDate.ToString("MMMM yyyy"),
                                    PercentAccomplished = acc.PercentAccomplished,
                                    Remarks = acc.Remarks,
                                    AuditorRemarks = acc.AuditorRemarks,
                                    Status = acc.Status
                                }
                            };
                        })
                        .ToList()
                })
                .ToList();

            return result;
        }
    }
}
