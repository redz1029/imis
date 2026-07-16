using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.CalendarActivityModule
{
    public interface ICalendarActivityRepository : IRepository<CalendarActivity, long>
    {
        Task<CalendarActivity?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<List<CalendarActivity>> GetAllAsync(CancellationToken cancellationToken);
        Task<List<CalendarActivity>> GetFilteredAsync(CalendarActivityFilter filter, CancellationToken cancellationToken);
        Task<List<CalendarActivity>> GetByMonthAsync(int month, int year, CancellationToken cancellationToken);
        Task<List<CalendarActivity>> GetByDateAsync(DateTime date, CancellationToken cancellationToken);
        Task<List<CalendarActivity>> SearchAsync(string keyword, CancellationToken cancellationToken);
        Task<bool> ExistsConflictAsync(CalendarActivity activity, CancellationToken cancellationToken);
        Task<CalendarActivity?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
