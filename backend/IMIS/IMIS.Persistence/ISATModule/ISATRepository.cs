using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.ISATModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.ISATModule
{
    public class ISATRepository : BaseRepository<ISAT, long, ImisDbContext, User>, IISATRepository
    {
        public ISATRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<List<ISAT>> GetCandidatesForUserAsync(string userId, int? officeId, CancellationToken cancellationToken)
        {
            var query = ReadOnlyDbContext.Set<ISAT>()
                .AsNoTracking()
              .Include(x => x.Office)
                .Include(x => x.ISATPeriod)
                .Include(x => x.EmployeeUser)
                .Include(x => x.ISATStrategicObjectiveSupported)
                    .ThenInclude(s => s.KraRoadMap)
                        .ThenInclude(r => r!.Kra)
                .Include(x => x.ISATStrategicObjectiveSupported)
                    .ThenInclude(s => s.KraRoadMapDeliverable)
                .Include(x => x.ISATStrategyContribution)
                    .ThenInclude(s => s.PgsDeliverable)
                .Include(x => x.ISATAnnualPerformanceCommitments)
                .Include(x => x.ISATSignatories)
                      .ThenInclude(s => s.Signatory)
                .Where(x => !x.IsDeleted)        
                .Where(x => x.EmployeeUserId == userId ||
                            x.ISATSignatories!.Any(s => !s.IsDeleted));

            if (officeId.HasValue)
            {
                query = query.Where(x => x.OfficeId == officeId.Value);
            }

            return await query
                .OrderByDescending(x => x.PostingDate)
                .AsSplitQuery()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<List<PgsDeliverableListDto>> GetPgsDeliverablesByOfficeAndPeriodAsync(int officeId, int periodId, CancellationToken cancellationToken)
        {
            var pgsId = await ReadOnlyDbContext.Set<PerfomanceGovernanceSystem>()
                .AsNoTracking()
                .Where(p => p.OfficeId == officeId && p.PgsPeriod.Id == periodId && !p.IsDeleted)
                .Select(p => p.Id)
                .FirstOrDefaultAsync(cancellationToken);

            if (pgsId == 0)
            {
                return new List<PgsDeliverableListDto>();
            }

            return await ReadOnlyDbContext.Set<PgsDeliverable>()
                .AsNoTracking()
                .Where(d => d.PerfomanceGovernanceSystemId == pgsId && !d.IsDeleted)
                .OrderBy(d => d.SortOrder)
                .Select(d => new PgsDeliverableListDto
                {
                    Id = d.Id,
                    DeliverableName = d.DeliverableName
                })
                .ToListAsync(cancellationToken);
        }

        public async Task<List<KraRoadMapDeliverableListDto>> GetDeliverablesByRoadMapIdAndYearAsync(long roadMapId, int year, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadMapDeliverable>()
                .AsNoTracking()
                .Where(x => x.KraRoadMapId == roadMapId && x.Year == year)
                .Select(x => new KraRoadMapDeliverableListDto
                {
                    Id = x.Id,
                    DeliverableDescription = x.DeliverableDescription,
                    Year = x.Year
                })
                .ToListAsync(cancellationToken);
        }

        public async Task<List<KraRoadMapListDto>> GetRoadMapListAsync(CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .OrderBy(x => ReadOnlyDbContext.Set<KraRoadmapProcessKraAssignment>()
                    .Where(a => a.KraId == x.KraId)
                    .Select(a => a.Id)
                    .FirstOrDefault())
                .Select(x => new KraRoadMapListDto
                {
                    Id = x.Id,
                    KraName = x.Kra != null ? x.Kra.Name : null,
                    StrategicObjective = x.Kra != null ? x.Kra.StrategicObjective : null
                })
                .ToListAsync(cancellationToken);
        }

        public async Task<UserOffices?> GetActiveUserOfficeAsync(string userId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<UserOffices>()
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.UserId == userId && x.IsActive, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<ISAT, long>> GetPaginatedAllAsync(int? officeId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .Include(x => x.Office)
                .Include(x => x.ISATPeriod)
                .Include(x => x.EmployeeUser)
                .Include(x => x.ISATStrategicObjectiveSupported)
                    .ThenInclude(s => s.KraRoadMap)
                        .ThenInclude(r => r!.Kra)
                .Include(x => x.ISATStrategicObjectiveSupported)
                    .ThenInclude(s => s.KraRoadMapDeliverable)
                .Include(x => x.ISATStrategyContribution)
                    .ThenInclude(s => s.PgsDeliverable)
                .Include(x => x.ISATAnnualPerformanceCommitments)
                .Include(x => x.ISATSignatories)
                     .ThenInclude(s => s.Signatory)
                .AsNoTracking()
                .Where(x => !x.IsDeleted)
                .AsQueryable();

            if (officeId.HasValue)
            {
                query = query.Where(x => x.OfficeId == officeId.Value);
            }

            return await EntityPageList<ISAT, long>.CreateAsync(query.OrderByDescending(x => x.PostingDate), page, pageSize, cancellationToken).ConfigureAwait(false);
        }

        public async Task<EntityPageList<ISAT, long>> GetPaginatedByUserIdAsync(string userId, int? officeId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .Include(x => x.Office)
                .AsNoTracking()
                .Where(x => !x.IsDeleted && x.EmployeeUserId == userId);

            if (officeId.HasValue)
            {
                query = query.Where(x => x.OfficeId == officeId.Value);
            }

            return await EntityPageList<ISAT, long>.CreateAsync(query.OrderByDescending(x => x.PostingDate), page, pageSize, cancellationToken).ConfigureAwait(false);
        }

        public async Task<Office?> GetOfficeWithParentAsync(int officeId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<Office>()
                .AsNoTracking()
                .Include(x => x.ParentOffice)
                .FirstOrDefaultAsync(x => x.Id == officeId, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<UserOffices?> GetOfficeHeadAsync(int officeId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<UserOffices>()
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.OfficeId == officeId && x.IsOfficeHead && x.IsActive, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<ISAT?> GetWithIncludesAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.ISATSignatories)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<ISAT?> GetByIsatIdAsync(long id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<ISAT>()
                .AsNoTracking()
                .Include(x => x.Office)
                .Include(x => x.ISATPeriod)
                .Include(x => x.EmployeeUser)
                .Include(x => x.ISATStrategicObjectiveSupported)
                    .ThenInclude(s => s.KraRoadMap)
                        .ThenInclude(r => r!.Kra)
                .Include(x => x.ISATStrategicObjectiveSupported)
                    .ThenInclude(s => s.KraRoadMapDeliverable)
                .Include(x => x.ISATStrategyContribution)
                    .ThenInclude(s => s.PgsDeliverable)
                .Include(x => x.ISATAnnualPerformanceCommitments)
                .Include(x => x.ISATSignatories)
                     .ThenInclude(s => s.Signatory)
                .AsSplitQuery()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}