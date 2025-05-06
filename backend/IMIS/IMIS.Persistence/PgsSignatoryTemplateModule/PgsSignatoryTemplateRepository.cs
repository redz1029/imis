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
            var query = _dbContext.PgsSignatoryTemplate
                .Where(k => !k.IsDeleted)
                .AsNoTracking();

            var team = await EntityPageList<PgsSignatoryTemplate, int>
             .CreateAsync(query, page, pageSize, cancellationToken)
             .ConfigureAwait(false);
            return team;
        }
        public async Task<IEnumerable<PgsSignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.PgsSignatoryTemplate
                 .Where(o => !o.IsDeleted)
                 .AsNoTracking()
                 .ToListAsync(cancellationToken)
                 .ConfigureAwait(false);
        }
        public new async Task<PgsSignatoryTemplate> SaveOrUpdateAsync(PgsSignatoryTemplate pgsSignatoryTemplate, CancellationToken cancellationToken)
        {
            if (pgsSignatoryTemplate == null) throw new ArgumentNullException(nameof(pgsSignatoryTemplate));

            var existingUserOffice = await _dbContext.PgsSignatoryTemplate
                .FirstOrDefaultAsync(d => d.Id == pgsSignatoryTemplate.Id, cancellationToken)
                .ConfigureAwait(false);

            if (existingUserOffice != null)
            {
                // Update the existing record's values
                _dbContext.Entry(existingUserOffice).CurrentValues.SetValues(pgsSignatoryTemplate);
            }
            else
            {
                // Add a new PgsAuditDetails if not found
                await _dbContext.PgsSignatoryTemplate.AddAsync(pgsSignatoryTemplate, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return pgsSignatoryTemplate;
        }
    }
}
