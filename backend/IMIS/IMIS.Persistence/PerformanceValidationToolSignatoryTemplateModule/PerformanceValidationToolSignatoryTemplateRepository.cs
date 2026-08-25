using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PerformanceValidationToolSignatoryTemplateModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PerformanceValidationToolSignatoryTemplateModule
{
    public class PerformanceValidationToolSignatoryTemplateRepository : BaseRepository<PerformanceValidationToolSignatoryTemplate, int, ImisDbContext, User>, IPerformanceValidationToolSignatoryTemplateRepository
    {
        public PerformanceValidationToolSignatoryTemplateRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<PerformanceValidationToolSignatoryTemplate?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PerformanceValidationToolSignatoryTemplate>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<PerformanceValidationToolSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<PerformanceValidationToolSignatoryTemplate, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        }
        public async Task<IEnumerable<PerformanceValidationToolSignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                 .AsNoTracking()
                 .ToListAsync(cancellationToken)
                 .ConfigureAwait(false);
        }
        public async Task<List<PerformanceValidationToolSignatoryTemplate>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(e => e.OfficeId == officeId && !e.IsDeleted && e.IsActive)
                .OrderBy(e => e.OrderLevel)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }       
    }
}
