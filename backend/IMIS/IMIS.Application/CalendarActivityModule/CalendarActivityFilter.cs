using IMIS.Domain;

namespace IMIS.Application.CalendarActivityModule
{
    public class CalendarActivityFilter
    {
       
        public string? Keyword { get; set; }
        public string? UserId { get; set; }     
        public int? OfficeId { get; set; }       
        public int? PgsPeriodId { get; set; }     
        public string? Category { get; set; }
        public CalendarActivityStatus? Status { get; set; }
        public DateTime? Date { get; set; }      
        public int? Month { get; set; }      
        public int? Year { get; set; }     
        public DateTime? FromDate { get; set; }     
        public DateTime? ToDate { get; set; }                
        public int Page { get; set; } = 1;      
        public int PageSize { get; set; } = 20;
    }
}
