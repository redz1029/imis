using Base.Abstractions;
using IMIS.Application.OfficeTypeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.OfficeTypeModule
{
    public class OfficeTypeRepository : BaseRepository<OfficeType, int, ImisDbContext>, IOfficeTypeRepository
    {
        public OfficeTypeRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<IEnumerable<OfficeType>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }       

    }
}
