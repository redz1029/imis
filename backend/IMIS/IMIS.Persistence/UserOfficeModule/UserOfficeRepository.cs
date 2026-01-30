using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.UserOfficeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.UserOfficeModule  
{
    public class UserOfficeRepository : BaseRepository<UserOffices, int, ImisDbContext, User>, IUserOfficeRepository
    {       
        public UserOfficeRepository(ImisDbContext dbContext) : base(dbContext)
        {
          
        }
        public async Task<IEnumerable<UserOffices>?> FilteByName(string name, int UserOfficeNoOfResults, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(a => EF.Functions.Like(a.UserId, $"{name}%"))
                .Take(UserOfficeNoOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<UserOffices?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<UserOffices>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<UserOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
                     
          return await EntityPageList<UserOffices, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
            
        }
        public async Task<IEnumerable<UserOffices>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
        public async Task<List<UserOffices>> GetByOfficeIdAsync(int officeId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(u => u.OfficeId == officeId && u.IsActive)
                .ToListAsync(cancellationToken);
        }
        public async Task<UserOffices?> GetOfficeHeadAsync(int officeId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<UserOffices>()
                .Where(uo => uo.OfficeId == officeId && uo.IsOfficeHead && !uo.IsDeleted)
                .FirstOrDefaultAsync(cancellationToken);
        }
        public async Task<bool> IsUserOfficeHeadAsync(string userId, int officeId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<UserOffices>() 
                .AnyAsync(uo => uo.UserId == userId && uo.OfficeId == officeId && uo.IsOfficeHead && !uo.IsDeleted, cancellationToken);
        }
    }
}
