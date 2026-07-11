using Base.Primitives;
using IMIS.Application.CalendarActivityModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.CalendarActivityModule
{
    public class CalendarActivityService : ICalendarActivityService
    {
        private readonly ICalendarActivityRepository _repository;
        private readonly UserManager<User> _userManager;

        public CalendarActivityService(ICalendarActivityRepository repository, UserManager<User> userManager)
        {
            _repository = repository;
            _userManager = userManager;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var calendarDto = dto as CalendarActivityDto;

            if (calendarDto == null)
                throw new ArgumentException("Invalid DTO type.");

            var activity = calendarDto.ToEntity();

            if (await _repository.ExistsConflictAsync(activity, cancellationToken))
            {
                throw new Exception("The selected schedule conflicts with another activity.");
            }
              
            if (activity.Id == 0)
            {
                _repository.Add(activity);
            }
            else
            {
                await _repository.UpdateAsync(activity, activity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _repository.SaveOrUpdateAsync(activity, cancellationToken).ConfigureAwait(false);
        }

        public async Task<CalendarActivityDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var activity = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return activity != null ? new CalendarActivityDto(activity) : null;
        }

        public async Task<List<CalendarActivityDto>> GetAllAsync(CancellationToken cancellationToken)
        {
            var activities = await _repository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            return activities.Select(a => new CalendarActivityDto(a)).ToList();
        }

        public async Task<List<CalendarActivityDto>> GetFilteredAsync(CalendarActivityFilter filter, CancellationToken cancellationToken)
        {
            var activities = await _repository.GetFilteredAsync(filter, cancellationToken).ConfigureAwait(false);
            return activities.Select(a => new CalendarActivityDto(a)).ToList();
        }

        public async Task<List<CalendarActivityDto>> GetByMonthAsync(int month, int year,  CancellationToken cancellationToken)
        {
            var activities = await _repository.GetByMonthAsync(month, year, cancellationToken).ConfigureAwait(false);
            return activities.Select(a => new CalendarActivityDto(a)).ToList();
        }

        public async Task<List<CalendarActivityDto>> GetByDateAsync(DateTime date, CancellationToken cancellationToken)
        {
            var activities = await _repository.GetByDateAsync(date, cancellationToken).ConfigureAwait(false);
            return activities.Select(a => new CalendarActivityDto(a)).ToList();
        }

        public async Task<List<CalendarActivityDto>> SearchAsync(string keyword, CancellationToken cancellationToken)
        {
            var activities = await _repository .SearchAsync(keyword, cancellationToken).ConfigureAwait(false);
            return activities.Select(a => new CalendarActivityDto(a)).ToList();
        }
    }
}