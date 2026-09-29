using Base.Abstractions;
using IMIS.Application.IQASignatoryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.IQASignatoryModule
{
    public class IQASignatoryRepository : BaseRepository<IQASignatory, long, ImisDbContext, User>, IIQASignatoryRepository
    {
        public IQASignatoryRepository(ImisDbContext context) 
            : base(context)
        {
        }

        public async Task<IEnumerable<IQASignatory>> GetByAuditProgrammeIdAsync(int auditProgrammeId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<IQASignatory>()
                .Where(s => s.AuditProgrammeId == auditProgrammeId && !s.IsDeleted)
                .Include(s => s.Signatory)
                .Include(s => s.IQASignatoryTemplate)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<IQASignatory>> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<IQASignatory>()
                .Where(s => s.AuditPlanId == auditPlanId && !s.IsDeleted)
                .Include(s => s.Signatory)
                .Include(s => s.IQASignatoryTemplate)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<IQASignatory>> GetByAuditScheduleIdAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<IQASignatory>()
                .Where(s => s.AuditScheduleId == auditScheduleId && !s.IsDeleted)
                .Include(s => s.Signatory)
                .Include(s => s.IQASignatoryTemplate)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<IQASignatory>> GetBySignatoryIdAsync(string signatoryId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<IQASignatory>()
                .Where(s => s.SignatoryId == signatoryId && !s.IsDeleted)
                .Include(s => s.AuditProgramme)
                .Include(s => s.AuditPlan)
                .Include(s => s.AuditSchedule)
                .ToListAsync(cancellationToken);
        }
    }
}
