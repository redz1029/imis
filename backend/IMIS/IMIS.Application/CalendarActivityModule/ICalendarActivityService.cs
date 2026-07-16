using Base.Abstractions;

namespace IMIS.Application.CalendarActivityModule
{
    public interface ICalendarActivityService : IService
    {
   
        Task<CalendarActivityDto?> GetByIdAsync(long id,  CancellationToken cancellationToken);
        Task<List<CalendarActivityDto>> GetAllAsync(CancellationToken cancellationToken);
        Task<List<CalendarActivityDto>> GetFilteredAsync(CalendarActivityFilter filter, CancellationToken cancellationToken);
        Task<List<CalendarActivityDto>> GetByMonthAsync(int month, int year, CancellationToken cancellationToken);
        Task<List<CalendarActivityDto>> GetByDateAsync(DateTime date, CancellationToken cancellationToken);
        Task<List<CalendarActivityDto>> SearchAsync(string keyword, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}