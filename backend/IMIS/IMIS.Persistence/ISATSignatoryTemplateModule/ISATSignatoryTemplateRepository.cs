using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.ISATSignatoryTemplateModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.ISATSignatoryTemplateModule
{
    public class ISATSignatoryTemplateRepository : BaseRepository<ISATSignatoryTemplate, int, ImisDbContext, User>, IISATSignatoryTemplateRepository
    {
        public ISATSignatoryTemplateRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<EntityPageList<ISATSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<ISATSignatoryTemplate, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        }
        public async Task<ISATSignatoryTemplate?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<ISATSignatoryTemplate>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<ISATSignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                 .AsNoTracking()
                 .ToListAsync(cancellationToken)
                 .ConfigureAwait(false);
        }
        public async Task<List<ISATSignatoryTemplate>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(e => e.OfficeId == officeId && !e.IsDeleted && e.IsActive)
                .OrderBy(e => e.OrderLevel)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
