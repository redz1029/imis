using Base.Abstractions;
using IMIS.Application.CalendarActivityModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.CalendarActivityModule
{
    public class CalendarActivityRepository : BaseRepository<CalendarActivity, long, ImisDbContext, User>, ICalendarActivityRepository
    {
        public CalendarActivityRepository(ImisDbContext dbContext)
            : base(dbContext)
        {
        }

        public async Task<CalendarActivity?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<CalendarActivity>()
                .AsNoTracking()
                .Include(x => x.User)
                .Include(x => x.Office)              
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }
        public async Task<List<CalendarActivity>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<CalendarActivity>()
                .AsNoTracking() 
                .Include(x => x.User)
                .Include(x => x.Office)             
                .OrderBy(x => x.StartDate)
                .ToListAsync(cancellationToken);
        }
        public async Task<List<CalendarActivity>> GetFilteredAsync(CalendarActivityFilter filter, CancellationToken cancellationToken)
        {
            IQueryable<CalendarActivity> query =
                ReadOnlyDbContext.Set<CalendarActivity>()
                .AsNoTracking()
                .Include(x => x.User)
                .Include(x => x.Office);

            if (!string.IsNullOrWhiteSpace(filter.UserId))
            {
                query = query.Where(x => x.UserId == filter.UserId);
            }

            if (filter.OfficeId.HasValue)
            {
                query = query.Where(x => x.OfficeId == filter.OfficeId);
            }
          
            if (!string.IsNullOrWhiteSpace(filter.Category))
            {
                query = query.Where(x => x.Category == filter.Category);
            }

            if (filter.Status.HasValue)
            {
                query = query.Where(x => x.Status == filter.Status.Value);
            }

            if (filter.Date.HasValue)
            {
                DateTime date = filter.Date.Value.Date;
                query = query.Where(x => x.StartDate.Date <= date && x.EndDate.Date >= date);
            }

            if (filter.Month.HasValue)
            {
                query = query.Where(x => x.StartDate.Month == filter.Month.Value);
            }

            if (filter.Year.HasValue)
            {
                query = query.Where(x => x.StartDate.Year == filter.Year.Value);
            }

            if (filter.FromDate.HasValue)
            {
                query = query.Where(x => x.StartDate >= filter.FromDate.Value);
            }

            if (filter.ToDate.HasValue)
            {
                query = query.Where(x => x.EndDate <= filter.ToDate.Value);
            }

            if (!string.IsNullOrWhiteSpace(filter.Keyword))
            {
                string keyword = filter.Keyword.Trim();

                query = query.Where(x =>
                    x.Title.Contains(keyword) ||
                    (x.Description != null &&
                     x.Description.Contains(keyword)) ||
                    (x.Location != null &&
                     x.Location.Contains(keyword)));
            }

            return await query.OrderBy(x => x.StartDate).ToListAsync(cancellationToken);
        }

        public async Task<List<CalendarActivity>> GetByMonthAsync(int month, int year, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<CalendarActivity>()
                .AsNoTracking()
                .Include(x => x.User)
                .Include(x => x.Office)              
                .Where(x =>
                    x.StartDate.Month == month &&
                    x.StartDate.Year == year)
                .OrderBy(x => x.StartDate)
                .ToListAsync(cancellationToken);
        }
        public async Task<List<CalendarActivity>> GetByDateAsync(DateTime date, CancellationToken cancellationToken)
        {
            date = date.Date;
            return await ReadOnlyDbContext.Set<CalendarActivity>()
                .AsNoTracking()
                .Include(x => x.User)
                .Include(x => x.Office)              
                .Where(x =>
                    x.StartDate.Date <= date &&
                    x.EndDate.Date >= date)
                .OrderBy(x => x.StartDate)
                .ToListAsync(cancellationToken);
        }
        public async Task<List<CalendarActivity>> SearchAsync(string keyword, CancellationToken cancellationToken)
        {
            keyword = keyword.Trim();
            return await ReadOnlyDbContext.Set<CalendarActivity>()
                .AsNoTracking()
                .Include(x => x.User)
                .Include(x => x.Office)             
                .Where(x =>
                    x.Title.Contains(keyword) ||
                    (x.Description != null && x.Description.Contains(keyword)) ||
                    (x.Location != null && x.Location.Contains(keyword)))
                .OrderBy(x => x.StartDate)
                .ToListAsync(cancellationToken);
        }
        public async Task<bool> ExistsConflictAsync(CalendarActivity activity, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<CalendarActivity>()
                .AsNoTracking()
                .AnyAsync(x =>
                    x.UserId == activity.UserId &&
                    x.Id != activity.Id &&
                    activity.StartDate < x.EndDate &&
                    activity.EndDate > x.StartDate,
                    cancellationToken);
        }
    }
}