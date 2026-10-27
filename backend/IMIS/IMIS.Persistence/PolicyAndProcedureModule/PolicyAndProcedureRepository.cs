using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PolicyAndProcedureModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PolicyAndProcedureModule
{
    public class PolicyAndProcedureRepository : BaseRepository<PolicyAndProcedure, long, ImisDbContext, User>,  IPolicyAndProcedureRepository
    {
        public PolicyAndProcedureRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<List<PolicyAndProcedure>> GetFilteredCandidatesAsync(PolicyAndProcedureFilter filter,  string userId, bool viewAll, bool includeChildOffices, CancellationToken cancellationToken)
        {
            IQueryable<PolicyAndProcedure> query = _entities
                .AsNoTracking()
                .Where(p => !p.IsDeleted);

            if (!viewAll)
            {
                query = query.Where(p =>
                    (p.Section != null &&
                     p.Section.UserOffices!.Any(u => u.UserId == userId && u.IsActive && !u.IsDeleted))

                    || (includeChildOffices &&
                        p.Section != null &&
                        p.Section.ParentOffice != null &&
                        p.Section.ParentOffice.UserOffices!.Any(u => u.UserId == userId && u.IsActive && !u.IsDeleted))

                    || p.PAPSignatories.Any(s => !s.IsDeleted));
            }

            if (filter.SectionId.HasValue)
            {
                query = query.Where(p =>
                    p.SectionId == filter.SectionId.Value ||
                    p.Section!.ParentOfficeId == filter.SectionId.Value);
            }

            if (filter.FromDate.HasValue)
                query = query.Where(p => p.EffectiveDate >= filter.FromDate.Value);

            if (filter.ToDate.HasValue)
                query = query.Where(p => p.EffectiveDate <= filter.ToDate.Value);

            if (!string.IsNullOrWhiteSpace(filter.Search))
            {
                var term = filter.Search.Trim();
                query = query.Where(p =>
                    (p.Title != null && p.Title.Contains(term)) ||
                    (p.DocumentCode != null && p.DocumentCode.Contains(term)));
            }

            return await query
                .Include(p => p.Section)
                    .ThenInclude(o => o!.UserOffices)
                .Include(p => p.Section)
                    .ThenInclude(o => o!.ParentOffice)
                .Include(p => p.PAPSignatories)
                .OrderByDescending(p => p.Id)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<PolicyAndProcedure?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(p => p.Section)
                    .ThenInclude(o => o!.UserOffices)
                .Include(p => p.Section)
                    .ThenInclude(o => o!.ParentOffice)
                .Include(p => p.PAPSignatories)
                .FirstOrDefaultAsync(p => p.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<PolicyAndProcedure?> GetWithIncludesAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(p => p.Section)
                    .ThenInclude(o => o!.UserOffices)
                .Include(p => p.Section)
                    .ThenInclude(o => o!.ParentOffice)
                .Include(p => p.PAPSignatories)
                .FirstOrDefaultAsync(p => p.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<PolicyAndProcedure?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext
                .Set<PolicyAndProcedure>()
                .FirstOrDefaultAsync(
                    d => d.Id == id,
                    cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<PolicyAndProcedure, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .AsNoTracking()
                .Include(p => p.Section)
                    .ThenInclude(o => o!.UserOffices)
                .Include(p => p.Section)
                    .ThenInclude(o => o!.ParentOffice)
                .Include(p => p.PAPSignatories)
                .OrderByDescending(p => p.Id);

            return await EntityPageList<PolicyAndProcedure, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
        }
    }
}