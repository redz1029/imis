using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.CalendarActivityModule
{
    public class CalendarActivityDto : BaseDto<CalendarActivity, long>
    {
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
        public string? UserFullName { get; set; }
        public int? OfficeId { get; set; }
        public string? OfficeName { get; set; }
        public int? ReminderMinutes { get; set; }
        public string? MeetingLink { get; set; }
        public string? AttachmentPath { get; set; }

        public CalendarActivityDto()
        {
        }
        [SetsRequiredMembers]
        public CalendarActivityDto(CalendarActivity entity)
        {
            Id = entity.Id;
            Title = entity.Title;
            Description = entity.Description;
            StartDate = entity.StartDate;
            EndDate = entity.EndDate;
            StartTime = entity.StartTime; 
            EndTime = entity.EndTime;
            IsAllDay = entity.IsAllDay;
            Color = entity.Color;
            Category = entity.Category;
            Location = entity.Location;
            Status = entity.Status;
            UserId = entity.UserId;
            OfficeId = entity.OfficeId;          
            ReminderMinutes = entity.ReminderMinutes;
            MeetingLink = entity.MeetingLink;
            AttachmentPath = entity.AttachmentPath;
        }

        public override CalendarActivity ToEntity()
        {
            return new CalendarActivity
            {
                Id = Id,
                Title = Title,
                Description = Description,
                StartDate = StartDate,
                EndDate = EndDate,
                StartTime = StartTime,
                EndTime = EndTime,
                IsAllDay = IsAllDay,
                Color = Color,
                Category = Category,
                Location = Location,
                Status = Status,
                UserId = UserId,
                OfficeId = OfficeId,               
                ReminderMinutes = ReminderMinutes,
                MeetingLink = MeetingLink,
                AttachmentPath = AttachmentPath
            };
        }
    }
}