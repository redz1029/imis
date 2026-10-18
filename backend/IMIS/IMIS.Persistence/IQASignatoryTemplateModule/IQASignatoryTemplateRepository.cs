using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.IQASignatoryTemplateModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.IQASignatoryTemplateModule
{
    public class IQASignatoryTemplateRepository : BaseRepository<IQASignatoryTemplate, int, ImisDbContext, User>, IIQASignatoryTemplateRepository
    {
        public IQASignatoryTemplateRepository(ImisDbContext context)
            : base(context)
        {
        }

        private IQueryable<IQASignatoryTemplate> WithDetails(IQueryable<IQASignatoryTemplate> query) => query
            .Include(t => t.Office)
            .Include(t => t.DefaultSignatory);

        public async Task<IQASignatoryTemplate?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await WithDetails(ReadOnlyDbContext.Set<IQASignatoryTemplate>().AsQueryable())
                .FirstOrDefaultAsync(t => t.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<IQASignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await WithDetails(_entities.AsNoTracking())
                .Where(t => !t.IsDeleted)
                .OrderBy(t => t.OfficeId)
                .ThenBy(t => t.OrderLevel)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<IQASignatoryTemplate>> GetByAuditEntityTypeAsync(string auditEntityType, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<IQASignatoryTemplate>()
                .Where(t => t.AuditEntityType == auditEntityType && !t.IsDeleted)
                .OrderBy(t => t.OrderLevel)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<IQASignatoryTemplate>> GetByOfficeIdAsync(int officeId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<IQASignatoryTemplate>()
                .Where(t => t.OfficeId == officeId && !t.IsDeleted && t.IsActive)
                .OrderBy(t => t.OrderLevel)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<IQASignatoryTemplate>> GetByStatusAsync(string status, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<IQASignatoryTemplate>()
                .Where(t => t.Status == status && !t.IsDeleted)
                .OrderBy(t => t.OrderLevel)
                .ToListAsync(cancellationToken);
        }

        public async Task<EntityPageList<IQASignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<IQASignatoryTemplate, int>.CreateAsync(
                WithDetails(_entities.AsNoTracking()).Where(t => !t.IsDeleted),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IQASignatoryTemplate?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(t => t.Id == id, cancellationToken);
        }
    }
}