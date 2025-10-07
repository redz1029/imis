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
            return await EntityPageList<Office, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<Office?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<Office>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<Office>?> FilterByName(string name, int officeNoOfResults, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(a => EF.Functions.Like(a.Name, $"{name}%"))
                .Take(officeNoOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<Office>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .Include(o => o.AuditorOffices)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }



        public async Task<List<Office>> GetAllForPgsAuditorAsync(CancellationToken cancellationToken)
        {
            // Admins can see all offices
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken);
        }

        public async Task<List<Office>> GetOfficesForAuditorAsync(string userId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditorOffices>()
                .Where(ao => ao.Auditor != null && ao.Auditor.UserId == userId && ao.Auditor.IsActive)
                .Select(ao => ao.Office!)
                .Distinct()
                .ToListAsync(cancellationToken);
        }

        public async Task<List<int>> GetAuditorOfficeIdsAsync(string userId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditorOffices>()
                .Where(ao => ao.Auditor != null && ao.Auditor.UserId == userId && ao.Auditor.IsActive)
                .Select(ao => ao.OfficeId)
                .Distinct()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }


        public async Task<IEnumerable<Office>?> GetAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken)
        {
            if (auditScheduleId.HasValue)
            {
                return await ReadOnlyDbContext.Set<AuditableOffices>()
                    .Where(ao => ao.AuditScheduleId == auditScheduleId)
                    .Select(a => a.Office!)
                    .Include (ao => ao.AuditorOffices)
                    .AsNoTracking()
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
            } else
            {
                return await ReadOnlyDbContext.Set<AuditableOffices>()
                   .Select(a => a.Office!)
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
                ? await _entities
                    .Where(o => !auditableOffices.Any(a => a.Id == o.Id))
                    .AsNoTracking()
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false)
                : await _entities
                    .AsNoTracking()
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
        }

        //// Recursively find the root parent office with an OfficeTypeId of 1
        //// Office type ID with a value of 1 is a Service and is considered the root office of CRMC's Organizational Structure.
        public async Task<Office> GetRootParentOffice(Office childOffice, CancellationToken cancellationToken)
        {
            int serviceOfficeTypeId = 1;

            if (childOffice.ParentOfficeId == null)
            {
                if (childOffice.OfficeTypeId == serviceOfficeTypeId)
                    return childOffice; // Root office, return itself
                else
                    throw new ArgumentException("Child office does not have a parent office.");
            }
            else
            {
                // Bawal maging magulang ng anak ang sarili
                if (childOffice.Id == childOffice.ParentOfficeId)
                    throw new ArgumentException("Child office cannot be its own parent.");

                var parentOffice = await _entities.FindAsync(childOffice.ParentOfficeId, cancellationToken).ConfigureAwait(false);
                if (parentOffice!.OfficeTypeId != serviceOfficeTypeId)
                {
                    // Recursively get the parent office until we find the root office
                    parentOffice = await GetRootParentOffice(parentOffice, cancellationToken).ConfigureAwait(false);
                }

                return parentOffice;
            }
        }       
    }
}
