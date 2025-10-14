using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsSignatoryTemplateModule
{
    public class PgsSignatoryTemplateRepository : BaseRepository<PgsSignatoryTemplate, int, ImisDbContext>, IPgsSignatoryTemplateRepository
    {
        public PgsSignatoryTemplateRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<EntityPageList<PgsSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {           
           return await EntityPageList<PgsSignatoryTemplate, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);            
        }
        public async Task<PgsSignatoryTemplate?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PgsSignatoryTemplate>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<PgsSignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities                
                 .AsNoTracking()
                 .ToListAsync(cancellationToken)
                 .ConfigureAwait(false);
        }       
        public async Task<List<PgsSignatoryTemplate>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(e => e.OfficeId == officeId && !e.IsDeleted && e.IsActive)
                .OrderBy(e => e.OrderLevel)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }       
    }
}
