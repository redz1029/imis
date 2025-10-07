using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AnnouncementModule
{
    public class AnnouncementDto : BaseDto<Announcement, int>
    {

        public string? Title { get; set; }
        public string? Description { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public bool IsActive { get; set; }

        public AnnouncementDto() { }

        [SetsRequiredMembers]
        public AnnouncementDto(Announcement announcement)
        {
            this.Id = announcement.Id;
            this.Title = announcement.Title;
            this.Description = announcement.Description;
            this.FromDate = announcement.FromDate;
            this.ToDate = announcement.ToDate;
            this.IsActive = announcement.IsActive;
        }

        public override Announcement ToEntity()
        {
            return new Announcement() {
                Id = Id,
                Title = Title,
                Description = Description,
                FromDate = FromDate,
                ToDate = ToDate,
                IsActive = IsActive,
            };
        }
    }
}
