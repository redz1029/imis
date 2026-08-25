using IMIS.Domain;
using Microsoft.AspNetCore.Http;

namespace IMIS.Application.CalendarActivityModule
{
    public class CalendarActivityForm
    {
        public long Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public TimeSpan? StartTime { get; set; }
        public TimeSpan? EndTime { get; set; }
        public bool IsAllDay { get; set; }
        public string? Color { get; set; }
        public string? Category { get; set; }
        public string? Location { get; set; }
        public CalendarActivityStatus? Status { get; set; }
        public string? UserId { get; set; }
        public int? OfficeId { get; set; }      
        public int? ReminderMinutes { get; set; }
        public string? MeetingLink { get; set; }
        public IFormFile? Attachment { get; set; }
        public bool RemoveAttachment { get; set; }
    }
}
