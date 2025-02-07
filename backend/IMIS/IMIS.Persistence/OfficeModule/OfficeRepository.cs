using Base.Abstractions;
using IMIS.Application.OfficeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.OfficeModule
{
    public class OfficeRepository(ImisDbContext dbContext) : BaseRepository<Office, int, ImisDbContext>(dbContext), IOfficeRepository
    {

       
        public async Task<IEnumerable<Office>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.Offices.Where(o => !o.IsDeleted).AsNoTracking().ToListAsync(cancellationToken).ConfigureAwait(false);
        }


       

    }
}
