using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.OfficeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.OfficeModule
{
    public class OfficeRepository(ImisDbContext dbContext) : BaseRepository<Office, int, ImisDbContext>(dbContext), IOfficeRepository
    {

        public async Task<EntityPageList<Office, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _dbContext.Offices.Where(k => !k.IsDeleted).AsNoTracking();

            var office = await EntityPageList<Office, int>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);

            return office;
        }
        public async Task<IEnumerable<Office>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken)
        {
            return await _dbContext.Offices
                .Where(a => EF.Functions.Like(a.Name, $"{name}%") && !a.IsDeleted)
                .Take(noOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<Office>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.Offices
                .Where(o => !o.IsDeleted)
                .Include(o => o.AuditorOffices)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<Office>?> GetAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken)
        {
            if (auditScheduleId.HasValue)
            {
                return await _dbContext.AuditableOffices
                    .Where(ao => ao.AuditScheduleId == auditScheduleId)
                    .Select(a => a.Office)
                    .Include (ao => ao.AuditorOffices)
                    .AsNoTracking()
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
            } else
            {
                return await _dbContext.AuditableOffices
                   .Select(a => a.Office)
                   .Distinct()
                   .Include(ao => ao.AuditorOffices)
                   .AsNoTracking()
                   .ToListAsync(cancellationToken)
                   .ConfigureAwait(false);
            }
        }
        public async Task<IEnumerable<Office>?> GetNonAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken)
        {
            var auditableOffices = auditScheduleId.HasValue 
                ? await GetAuditableOffices(auditScheduleId.Value, cancellationToken).ConfigureAwait(false)
                : await GetAuditableOffices(null, cancellationToken).ConfigureAwait(false);

            return auditableOffices != null && auditableOffices.Count() > 0 
                ? await _dbContext.Offices
                    .Where(o => !auditableOffices.Any(a => a.Id == o.Id))
                    .AsNoTracking()
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false)
                : await _dbContext.Offices
                    .AsNoTracking()
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
        }     
    }
}
