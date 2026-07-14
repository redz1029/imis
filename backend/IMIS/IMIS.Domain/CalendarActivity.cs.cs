using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class CalendarActivity : Entity<long>
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
        public int? OfficeId { get; set; }           
        public int? ReminderMinutes { get; set; }       
        public string? MeetingLink { get; set; }          
        public string? AttachmentPath { get; set; }                     
        [ForeignKey(nameof(UserId))]
        public virtual User? User { get; set; }
        [ForeignKey(nameof(OfficeId))]
        public virtual Office? Office { get; set; }    
    }
}
