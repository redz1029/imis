using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PolicyAndProcedureSignatoryTemplateModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PolicyAndProcedureSignatoryTemplateModule
{
    public class PolicyAndProcedureSignatoryTemplateRepository : BaseRepository<PolicyAndProcedureSignatoryTemplate, int, ImisDbContext, User>, IPolicyAndProcedureSignatoryTemplateRepository
    {
        public PolicyAndProcedureSignatoryTemplateRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<PolicyAndProcedureSignatoryTemplate?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PolicyAndProcedureSignatoryTemplate>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<PolicyAndProcedureSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<PolicyAndProcedureSignatoryTemplate, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        }
        public async Task<IEnumerable<PolicyAndProcedureSignatoryTemplate>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                 .AsNoTracking()
                 .ToListAsync(cancellationToken)
                 .ConfigureAwait(false);
        }
        public async Task<List<PolicyAndProcedureSignatoryTemplate>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(e => e.OfficeId == officeId && !e.IsDeleted && e.IsActive)
                .OrderBy(e => e.OrderLevel)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
