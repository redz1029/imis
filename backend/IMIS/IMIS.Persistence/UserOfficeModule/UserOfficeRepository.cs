using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.UserOfficeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.UserOfficeModule
{
    public class UserOfficeRepository : BaseRepository<UserOffices, int, ImisDbContext>, IUserOfficeRepository
    {       
        public UserOfficeRepository(ImisDbContext dbContext) : base(dbContext)
        {
          
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
    }
}
