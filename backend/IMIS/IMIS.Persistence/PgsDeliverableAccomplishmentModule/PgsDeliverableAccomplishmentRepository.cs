using System.Globalization;
using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentRepository(ImisDbContext dbContext)
    : BaseRepository<PgsDeliverableAccomplishment, long, ImisDbContext, User>(dbContext), IPgsDeliverableAccomplishmentRepository
    {
        public async Task<EntityPageList<PgsDeliverableAccomplishment, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<PgsDeliverableAccomplishment, long>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        }

        public async Task<PgsDeliverableAccomplishmentFilterDto> GetByFilterAsync(int? periodId, int? officeId, long? pgsId, CancellationToken cancellationToken)
        {
            var query = dbContext.Set<PgsDeliverable>()
                .AsNoTracking()
                .Where(d =>
                    !d.IsDeleted &&
                    d.PerfomanceGovernanceSystem != null &&
                    !d.PerfomanceGovernanceSystem.IsDeleted);

            if (pgsId.HasValue)
            {
                query = query.Where(d => d.PerfomanceGovernanceSystemId == pgsId.Value);
            }

            if (periodId.HasValue)
            {
                query = query.Where(d => d.PerfomanceGovernanceSystem!.PgsPeriod.Id == periodId.Value);
            }

            if (officeId.HasValue)
            {
                query = query.Where(d => d.PerfomanceGovernanceSystem!.OfficeId == officeId.Value);
            }

            var rows = await query
                .OrderBy(d => d.SortOrder)
                .Select(d => new
                {
                    d.Id,
                    d.DeliverableName,
                    OfficeName = d.PerfomanceGovernanceSystem!.Office.Name,
                    StartDate = d.PerfomanceGovernanceSystem.PgsPeriod.StartDate,
                    EndDate = d.PerfomanceGovernanceSystem.PgsPeriod.EndDate,
                    Accomplishments = d.PgsDeliverableAccomplishments!
                        .Where(a => !a.IsDeleted)
                        .OrderBy(a => a.PostingDate)         
                        .ThenBy(a => a.Id)
                        .Select(a => new
                        {
                            a.Id,
                            a.Status,
                            a.PercentAccomplished,
                            a.PostingDate,
                            a.Remarks,
                            a.AuditorRemarks
                        })
                        .ToList()
                })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            if (rows.Count == 0)
            {
                return new PgsDeliverableAccomplishmentFilterDto();
            }

            var firstRow = rows[0];

            string startMonth = firstRow.StartDate.ToString("MMMM", CultureInfo.InvariantCulture);
            string endMonth = firstRow.EndDate.ToString("MMMM", CultureInfo.InvariantCulture);
            string startYear = firstRow.StartDate.ToString("yyyy", CultureInfo.InvariantCulture);
            string endYear = firstRow.EndDate.ToString("yyyy", CultureInfo.InvariantCulture);

            string periodName;

            if (firstRow.StartDate.Year == firstRow.EndDate.Year)
            {
                periodName = firstRow.StartDate.Month == firstRow.EndDate.Month
                    ? $"{startMonth} {startYear}"
                    : $"{startMonth} to {endMonth} {endYear}";
            }
            else
            {
                periodName = $"{startMonth} {startYear} to {endMonth} {endYear}";
            }

            var result = new PgsDeliverableAccomplishmentFilterDto
            {
                PeriodName = periodName,
                OfficeName = firstRow.OfficeName,

                PgsDeliverableAccomplishmenItem = rows
                    .Select(r => new PgsDeliverableAccomplishmenItemDto
                    {
                        PgsDeliverableId = r.Id,
                        DeliverableName = r.DeliverableName,

                        Accomplishments = r.Accomplishments
                            .OrderBy(a => a.PostingDate.Year)
                            .ThenBy(a => a.PostingDate.Month)
                            .ThenBy(a => a.Id)
                            .Select(a => new AccomplishmentItemDto
                            {
                                Id = a.Id,
                                Status = a.Status.ToString(),
                                DeliverableName = r.DeliverableName,
                                PercentAccomplished = a.PercentAccomplished,
                                PostingMonth = a.PostingDate.ToString("MMMM", CultureInfo.InvariantCulture),
                                Remarks = a.Remarks,
                                AuditorRemarks = a.AuditorRemarks,
                            })
                            .ToList()
                    })
                    .ToList()
            };

            return result;
        }
        public async Task<int> GetAttachmentCountByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.PgsDeliverableId == deliverableId && !string.IsNullOrWhiteSpace(x.AttachmentPath))
                .CountAsync(cancellationToken);
        }
        public async Task<List<PgsDeliverableAccomplishment>> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken)
        {
            return await _entities
            .Where(a => a.PgsDeliverableId == deliverableId)
            .Include(a => a.User)
            .ToListAsync(cancellationToken);
        }
    }
}
