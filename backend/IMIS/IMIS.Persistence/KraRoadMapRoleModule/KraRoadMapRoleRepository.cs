using Base.Abstractions;
using IMIS.Application.KraRoadMapRoleAssignmentModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadMapRoleModule
{
    public class KraRoadMapRoleRepository : BaseRepository<KraRoadMapRole, int, ImisDbContext>, IKraRoadMapRoleRepository
    {
        public KraRoadMapRoleRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        //public async Task<KraRoadMapRole?> GetByRoleIdAsync(string roleId, CancellationToken cancellationToken)
        //{          
        //    return await ReadOnlyDbContext.Set<KraRoadMapRole>()
        //   .Include(x => x.Kra) 
        //   .Where(x => x.RoleId == roleId)
        //   .FirstOrDefaultAsync(cancellationToken);
        //}
        public async Task<List<KraRoadMapRole>> GetByRoleIdAsync(string roleId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadMapRole>()
                .Include(x => x.Kra)
                .Where(x => x.RoleId == roleId)
                .ToListAsync(cancellationToken);
        }


        public async Task<IEnumerable<KraRoadMapRole>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .Include(x => x.Kra)           
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }

    }
}
