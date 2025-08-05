using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditorModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditorModule
{
    public class AuditorRepository(ImisDbContext dbContext) : BaseRepository<Auditor, int, ImisDbContext>(dbContext), IAuditorRepository
    {
        public async Task<EntityPageList<Auditor, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _dbContext.Auditors.Where(k => !k.IsDeleted).AsNoTracking();
            var auditor = await EntityPageList<Auditor, int>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);           
            return auditor;
        }
        public async Task<IEnumerable<Auditor>?> FilteByName(string name, int auditorNoOfResults, CancellationToken cancellationToken)
        {
            return await _dbContext.Auditors
                .Where(a => EF.Functions.Like(a.Name, $"{name}%") && !a.IsDeleted)
                .Take(auditorNoOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<Auditor>?> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.Auditors
                .Where(a => !a.IsDeleted)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
