using Base.Primitives;

namespace IMIS.Domain
{
    public class Announcement : Entity<int>
    {
        public string? Title { get; set; }
        public string? Description { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public bool IsActive { get; set; }
    }
}
