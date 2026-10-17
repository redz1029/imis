using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditPlanEntryModule
{
    public class AuditPlanEntryRepository(ImisDbContext dbContext)
        : BaseRepository<AuditPlanEntry, int, ImisDbContext, User>(dbContext), IAuditPlanEntryRepository
    {
        // --- Main entity retrieval ---

        public async Task<AuditPlanEntry?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditPlanEntry>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<AuditPlanEntry?> GetByAuditPlanEntryIdAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditPlanEntry>()
                .Include(x => x.IsoAuditProcesses)
                .Include(x => x.ResponsiblePersons)
                .Include(x => x.IsoAuditors)
                .Include(x => x.IsoStandardAuditPlans)
                .Include(x => x.AuditPlanProcesses)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditPlanEntry>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.IsoAuditProcesses)
                .Include(x => x.ResponsiblePersons)
                .Include(x => x.IsoAuditors)
                .Include(x => x.IsoStandardAuditPlans)
                .Include(x => x.AuditPlanProcesses)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditPlanEntry>> GetAllByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.AuditPlanId == auditPlanId)
                .Include(x => x.IsoAuditProcesses)
                .Include(x => x.ResponsiblePersons)
                .Include(x => x.IsoAuditors)
                .Include(x => x.IsoStandardAuditPlans)
                .Include(x => x.AuditPlanProcesses)
                .ToListAsync(cancellationToken);
        }

        public async Task<EntityPageList<AuditPlanEntry, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditPlanEntry, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken);
        }

        // --- Child collection helpers ---

        public async Task<List<int>> GetExistingIsoAuditProcessIdsAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == auditPlanEntryId)
                .SelectMany(x => x.IsoAuditProcesses.Select(p => p.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task AddIsoAuditProcessesAsync(List<IsoAuditProcess> processes, CancellationToken cancellationToken)
        {
            //  Changed from ReadOnlyDbContext to GetDbContext()
            await GetDbContext().Set<IsoAuditProcess>().AddRangeAsync(processes, cancellationToken);
            await GetDbContext().SaveChangesAsync(cancellationToken);
        }

        public async Task<List<int>> GetExistingResponsiblePersonIdsAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == auditPlanEntryId)
                .SelectMany(x => x.ResponsiblePersons.Select(p => p.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task AddResponsiblePersonsAsync(List<AuditPlanPersonResponsible> persons, CancellationToken cancellationToken)
        {
            //  Changed from ReadOnlyDbContext to GetDbContext()
            await GetDbContext().Set<AuditPlanPersonResponsible>().AddRangeAsync(persons, cancellationToken);
            await GetDbContext().SaveChangesAsync(cancellationToken);
        }

        public async Task<List<int>> GetExistingIsoAuditorIdsAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == auditPlanEntryId)
                .SelectMany(x => x.IsoAuditors.Select(p => p.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task AddIsoAuditorsAsync(List<IsoAuditor> auditors, CancellationToken cancellationToken)
        {
            //  Changed from ReadOnlyDbContext to GetDbContext()
            await GetDbContext().Set<IsoAuditor>().AddRangeAsync(auditors, cancellationToken);
            await GetDbContext().SaveChangesAsync(cancellationToken);
        }

        public async Task<List<long>> GetExistingIsoStandardAuditPlanIdsAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == auditPlanEntryId)
                .SelectMany(x => x.IsoStandardAuditPlans.Select(p => p.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task AddIsoStandardAuditPlansAsync(List<IsoStandardAuditPlan> standards, CancellationToken cancellationToken)
        {
            //  Changed from ReadOnlyDbContext to GetDbContext()
            await GetDbContext().Set<IsoStandardAuditPlan>().AddRangeAsync(standards, cancellationToken);
            await GetDbContext().SaveChangesAsync(cancellationToken);
        }

        public async Task<List<int>> GetExistingAuditPlanProcessIdsAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == auditPlanEntryId)
                .SelectMany(x => x.AuditPlanProcesses.Select(p => p.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task AddAuditPlanProcessesAsync(List<AuditPlanProcess> processes, CancellationToken cancellationToken)
        {
            //  Changed from ReadOnlyDbContext to GetDbContext()
            await GetDbContext().Set<AuditPlanProcess>().AddRangeAsync(processes, cancellationToken);
            await GetDbContext().SaveChangesAsync(cancellationToken);
        }

      
    }
}