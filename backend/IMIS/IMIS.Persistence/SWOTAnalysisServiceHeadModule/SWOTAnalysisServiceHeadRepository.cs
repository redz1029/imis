using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.SWOTAnalysisServiceHeadModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.SWOTAnalysisServiceHeadModule
{
    public class SWOTAnalysisServiceHeadRepository : BaseRepository<SWOTAnalysisServiceHead, long, ImisDbContext, User>, ISWOTAnalysisServiceHeadRepository
    {
        public SWOTAnalysisServiceHeadRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<SWOTAnalysisServiceHead?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {

            return await _entities.FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<SWOTAnalysisServiceHead?> GetByIdWithChildrenAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(s => s.SWOTAnalysisSWDeliverablesServiceHead)
                    .ThenInclude(d => d.InternalContext)
                .Include(s => s.SWOTAnalysisOTDeliverablesServiceHead)
                    .ThenInclude(d => d.ExternalContext)
                .Include(s => s.DepartmentUser)               
                .Include(s => s.ServiceHeadUser)
                .Include(s => s.Department)
                .FirstOrDefaultAsync(s => s.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<SWOTAnalysisServiceHead, long>> GetPaginatedAllAsync(int? officeId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .Include(x => x.Department)
                .AsNoTracking()
                .AsQueryable();

            if (officeId.HasValue)
            {
                query = query.Where(x => x.Department != null && x.Department.Id == officeId.Value);
            }

            return await EntityPageList<SWOTAnalysisServiceHead, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
        }

        public async Task<EntityPageList<SWOTAnalysisServiceHead, long>> GetPaginatedByUserIdAsync(string userId, int? officeId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .Include(x => x.Department)
                .AsNoTracking()
                .Where(x => x.DepartmentChairUserId == userId);

            if (officeId.HasValue)
            {
                query = query.Where(x => x.Department != null && x.Department.Id == officeId.Value);
            }

            return await EntityPageList<SWOTAnalysisServiceHead, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
        }
    }
}
