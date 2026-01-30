using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.SWOTAnalysisModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.SWOTAnalysisModule
{
    public class SWOTAnalysisRepository : BaseRepository<SWOTAnalysis, int, ImisDbContext, User>, ISWOTAnalysisRepository
    {
        public SWOTAnalysisRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<List<SWOTAnalysisDto>?> FilterByYearAsync(int year, int noOfResults, CancellationToken cancellationToken)
        {
            var query = ReadOnlyDbContext.Set<SWOTAnalysis>()
                .AsNoTracking()
                .Where(s => s.PostingDate.HasValue
                         && s.PostingDate.Value.Year == year)
                .OrderByDescending(s => s.PostingDate)
                .Take(noOfResults);

            var result = await query
                .Select(s => new SWOTAnalysisDto(s))
                .ToListAsync(cancellationToken);

            return result.Any() ? result : null;
        }
        public async Task<List<SWOTAnalysisDto>?> FilterByYearByUserAsync(string userId, int year, int noOfResults, CancellationToken cancellationToken)
        {
            var query = ReadOnlyDbContext.Set<SWOTAnalysis>()
                .AsNoTracking()
                .Where(s =>
                    s.UserId == userId &&
                    s.PostingDate.HasValue &&
                    s.PostingDate.Value.Year == year)
                .OrderByDescending(s => s.PostingDate)
                .Take(noOfResults);

            var result = await query
                .Select(x => new SWOTAnalysisDto(x))
                .ToListAsync(cancellationToken);

            return result.Any() ? result : null;
        }


        public async Task<SWOTAnalysis?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<SWOTAnalysis>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<SWOTAnalysis, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<SWOTAnalysis, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<List<SWOTAnalysis>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<SWOTAnalysis>()
                .ToListAsync(cancellationToken);
        }

        public async Task<List<SWOTAnalysis>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            var entities = await ReadOnlyDbContext.Set<SWOTAnalysis>()
                .Where(x => x.UserId == userId)
                .ToListAsync(cancellationToken);

            return entities.Count == 0 ? null : entities;
        }
    }
}
